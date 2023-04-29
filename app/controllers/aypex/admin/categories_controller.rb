module Aypex
  module Admin
    class CategoriesController < ResourceController
      belongs_to "aypex/base_category"

      before_action :set_permalink_part, only: [:edit]

      def index
      end

      def new
        @image = @object.build_image
        super
      end

      def products_panel
        if params[:category_id].blank?
          head :no_content
        else
          @category = Category.find(params[:category_id])
        end
      end

      def update
        successful = @category.transaction do
          parent_id = params[:category][:parent_id]
          set_position
          set_parent(parent_id)

          @category.save!

          # regenerate permalink
          regenerate_permalink if parent_id

          set_permalink_params

          # check if we need to rename child categories if parent name or permalink changes
          @update_children = true if params[:category][:name] != @category.name || params[:category][:permalink] != @category.permalink
          @category.update(category_params)
        end

        if successful
          flash_message_for(@category, :successfully_updated)

          # rename child categories
          rename_child_categories if @update_children

          respond_with(@category) do |format|
            format.html { redirect_to aypex.edit_admin_base_category_category_path(@base_category.id, @category.id) }
          end
        else
          respond_with(@category) do |format|
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def remove_icon
        if @category.image.destroy

          dispatch_notice(I18n.t("aypex.admin.icon_removed"), :success)
          redirect_to aypex.edit_admin_base_category_category_url(@base_category.id, @category.id)
        else
          dispatch_notice(I18n.t("aypex.admin.cannot_remove_icon"), :error)
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def successful_reposition_actions
        reload_category_and_set_new_permalink(@category)
        update_permalinks_on_child_categories

        respond_to do |format|
          format.turbo_stream { render "aypex/admin/base_categories/reposition" }
        end
      end

      def reload_category_and_set_new_permalink(category)
        category.reload
        category.set_permalink
        category.save!
      end

      def update_permalinks_on_child_categories
        @category.descendants.each do |category|
          reload_category_and_set_new_permalink(category)
        end
      end

      def location_after_save
        aypex.edit_admin_base_category_category_path(@base_category.id, @category.id)
      end

      def parent_data
        if action_name == "index"
          nil
        else
          super
        end
      end

      def set_permalink_part
        @permalink_part = @category.permalink.split("/").last
        @parent_permalink = @category.permalink.split("/")[0...-1].join("/")
        @parent_permalink += "/" unless @parent_permalink.blank?
      end

      def category_params
        params.require(:category).permit(permitted_category_attributes)
      end

      def set_position
        new_position = params[:category][:position]
        @category.child_index = new_position.to_i if new_position
      end

      def set_parent(parent_id)
        @category.parent = current_store.categories.find(parent_id) if parent_id
      end

      def set_permalink_params
        set_permalink_part

        if params[:category][:permalink_part].present?
          params[:category][:permalink] = @parent_permalink + params[:category][:permalink_part]
        end
      end

      def rename_child_categories
        @category.descendants.each do |category|
          reload_category_and_set_permalink(category)
        end
      end

      def regenerate_permalink
        reload_category_and_set_permalink(@category)
        @update_children = true
      end

      def reload_category_and_set_permalink(category)
        category.reload
        category.set_permalink
        category.save!
      end

      def scope
        current_store.categories
      end
    end
  end
end
