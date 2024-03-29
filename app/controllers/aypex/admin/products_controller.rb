module Aypex
  module Admin
    class ProductsController < ResourceController
      include Aypex::Admin::ProductConcern

      before_action :load_data, except: [:index, :bulk_update_status]
      before_action :set_product_defaults, only: :new
      before_action :load_option_values, only: [:edit_image, :new_image]

      create.before :create_before
      update.before :update_before
      update.before :skip_updating_status
      update.after :update_status

      def bulk_update_status
        @selected_products = Product.where(id: params.fetch(:product_ids, []).compact)

        if params[:button] == "active"
          @selected_products.update_all(status: :active)
        elsif params[:button] == "draft"
          @selected_products.update_all(status: :draft)
        elsif params[:button] == "archive"
          @selected_products.update_all(status: :archived)
        end

        dispatch_notice("#{@selected_products.count} #{I18n.t("aypex.admin.products_marked_as")} #{params[:button].capitalize}", :success)
        redirect_to action: :index
      end

      def show
        session[:return_to] ||= request.referer
        redirect_to action: :edit
      end

      def update
        if params[:product][:category_ids].present?
          params[:product][:category_ids] = params[:product][:category_ids].reject(&:empty?)
        end
        if params[:product][:option_type_ids].present?
          params[:product][:option_type_ids] = params[:product][:option_type_ids].reject(&:empty?)
        end

        super
      end

      def clone
        @new = @product.duplicate

        if @new.persisted?
          dispatch_notice(I18n.t("aypex.admin.product_cloned"), :success)
          redirect_to aypex.edit_admin_product_url(@new)
        else
          dispatch_notice(I18n.t("aypex.admin.product_not_cloned", error: @new.errors.full_messages.to_sentence), :error)
          redirect_to aypex.admin_products_url
        end
      rescue ActiveRecord::RecordInvalid => e
        # Handle error on uniqueness validation on product fields
        dispatch_notice(I18n.t("aypex.admin.product_not_cloned", error: e.message), :error)
        redirect_to aypex.admin_products_url
      end

      def add_stock
        @variant = @product.variants_including_master.find_by(id: params[:variant_id])
        @stock_locations = StockLocation.accessible_by(current_ability)
        if @stock_locations.empty?
          dispatch_notice(I18n.t("aypex.admin.stock_management_requires_a_stock_location"), :error)
          redirect_to aypex.admin_stock_locations_path
        end
      end

      def remove_from_category
        @category = Category.find(params[:category_id])

        if @object.categories.delete(@category)
          respond_to do |format|
            format.turbo_stream { render "aypex/admin/categories/remove_from_category" }
          end
        else
          stream_flash_alert(message: I18n.t("aypex.admin.could_not_remove_from_category"), kind: :error)
        end
      end

      def new_image
        @image = @object.images.build
      end

      def edit_image
        @image = @product.images.find(params[:image_id])
      end

      def update_availability
        if @object.update(status: permitted_resource_params[:status])
        else
          stream_flash_alert(message: I18n.t("aypex.admin.status_could_not_be_updated"), kind: :error)
        end
      end

      def update_cost_currency
        if @object.update(cost_currency: permitted_resource_params[:cost_currency])
        else
          stream_flash_alert(message: I18n.t("aypex.admin.cost_currency_could_not_be_updated"), kind: :error)
        end
      end

      def update_promotionable
        if @object.update(promotionable: permitted_resource_params[:promotionable])
        else
          stream_flash_alert(message: I18n.t("aypex.admin.promotionable_could_not_be_updated"), kind: :error)
        end
      end

      protected

      def find_resource
        product_scope.with_deleted.friendly.find(params[:id])
      end

      def location_after_save
        aypex.edit_admin_product_path(@product)
      end

      def load_data
        @categories = Category.order(:name)
        @option_types = OptionType.order(:name)
        @tax_categories = TaxCategory.order(:name)
        @shipping_categories = ShippingCategory.order(:name)
      end

      def set_product_defaults
        @product.shipping_category ||= @shipping_categories&.first
      end

      def skip_updating_status
        @new_status = params[:product].delete(:status)
      end

      def update_status
        return if @new_status == @product.status
        return if cannot?(:activate, Aypex::Product) && @new_status&.to_sym == :active

        event_to_fire = @product.status_transitions.find { |transition| transition.from == @product.status && transition.to == @new_status }&.event
        @product.send(event_to_fire) if event_to_fire
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        params[:q][:deleted_at_null] ||= "1"

        params[:q][:s] ||= "name asc"

        per_page_limit = params[:per_page] || current_store.admin_products_per_page

        @collection = product_scope

        # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
        # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
        if params[:q][:deleted_at_null] == "0"
          @collection = @collection.with_deleted
        end
        # @search needs to be defined as this is passed to search_form_for
        # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
        # This is to include all products and not just deleted products.
        @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == "deleted_at_null" })
        @collection = @search.result.includes(product_includes)

        @pagy, @collection = pagy(@collection, items: per_page_limit)

        @collection
      end

      def create_before
        return if params[:product][:prototype_id].blank?

        @prototype = Aypex::Prototype.find(params[:product][:prototype_id])
      end

      def update_before
        # NOTE: we only reset the product properties if we're receiving a post from the form on that tab
        return unless params[:clear_product_properties]

        params[:product] ||= {}
      end

      def product_includes
        {
          tax_category: [],
          master: [],
          variants: [:prices]
        }
      end

      def permitted_resource_params
        if cannot?(:activate, @product) && @new_status&.to_sym == :active
          super.except(:status, :make_active_at).permit!
        else
          super
        end
      end

      private

      def variant_stock_includes
        [stock_items: :stock_location, option_values: :option_type]
      end

      def load_option_values
        @option_values = []
        @option_value_ids = []

        @product.variants.each do |variant|
          variant.option_values.each do |ov|
            next unless ov.option_type.image_filterable

            @option_values << ov
          end
        end

        @option_values.uniq!
        @option_value_ids = @option_values.map(&:id)
      end
    end
  end
end
