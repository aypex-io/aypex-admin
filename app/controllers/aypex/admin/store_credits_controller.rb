module Aypex
  module Admin
    class StoreCreditError < StandardError; end

    class StoreCreditsController < Aypex::Admin::BaseController
      before_action :load_user
      before_action :load_categories, only: [:new, :edit]
      before_action :load_store_credit, only: [:new, :edit, :update]
      before_action :ensure_unused_store_credit, only: [:update]

      def index
        @store_credits = @user.store_credits.for_store(current_store).includes(:category).reverse_order
      end

      def create
        @store_credit = @user.store_credits.build(
          permitted_store_credit_params.merge(
            created_by: try_aypex_current_user,
            action_originator: try_aypex_current_user,
            store: current_store
          )
        )

        if @store_credit.save
          flash_message_for(@store_credit, :successfully_created)
          redirect_to aypex.edit_admin_user_path(@user)
        else
          load_categories
          dispatch_notice(I18n.t("aypex.admin.unable_to_create"), :error)
          render :new, status: :unprocessable_entity
        end
      end

      def update
        @store_credit.assign_attributes(permitted_store_credit_params)
        @store_credit.created_by = try_aypex_current_user

        if @store_credit.save
          flash_message_for(@store_credit, :successfully_updated)
          redirect_to aypex.edit_admin_user_path(@user)
        else
          load_categories
          dispatch_notice(I18n.t("aypex.admin.unable_to_update"), :error)

          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @store_credit = @user.store_credits.for_store(current_store).find(params[:id])
        ensure_unused_store_credit

        if @store_credit.destroy
          flash_message_for(@store_credit, :successfully_removed)
        else
          render plain: I18n.t("aypex.admin.unable_to_delete"), status: :unprocessable_entity
        end

        respond_with(@store_credit) do |format|
          format.html { redirect_to aypex.edit_admin_user_path(@user) }
        end
      end

      protected

      def permitted_store_credit_params
        params.require(:store_credit).permit(permitted_store_credit_attributes)
      end

      private

      def load_user
        @user = Aypex::Config.user_class.find_by(id: params[:user_id])

        unless @user
          dispatch_notice(I18n.t("aypex.admin.user_not_found"), :error)
          redirect_to aypex.admin_path
        end
      end

      def load_categories
        @credit_categories = Aypex::StoreCreditCategory.order(:name)
      end

      def load_store_credit
        @store_credit = scope.find_by(id: params[:id]) || scope.new
      end

      def scope
        current_store.store_credits
      end

      def ensure_unused_store_credit
        unless @store_credit.amount_used.zero?
          raise StoreCreditError, I18n.t("aypex.admin.cannot_change_used_store_credit")
        end
      end
    end
  end
end
