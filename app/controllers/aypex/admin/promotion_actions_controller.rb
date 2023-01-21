class Aypex::Admin::PromotionActionsController < Aypex::Admin::BaseController
  before_action :load_promotion, only: [:create, :destroy]
  before_action :validate_promotion_action_type, only: :create

  def create
    @calculators = Aypex::Promotion::Actions::CreateItemAdjustments.calculators
    @promotion_action = params[:action_type].constantize.new(params[:promotion_action])
    @promotion_action.promotion = @promotion
    if @promotion_action.save
      dispatch_notice(I18n.t("aypex.admin.successfully_created", resource: I18n.t("aypex.admin.promotion_action")), :success)
    end
    respond_to do |format|
      format.html { redirect_to aypex.edit_admin_promotion_path(@promotion) }
    end
  end

  def destroy
    @promotion_action = @promotion.promotion_actions.find(params[:id])
    if @promotion_action.destroy
      dispatch_notice(I18n.t("aypex.admin.successfully_removed", resource: I18n.t("aypex.admin.promotion_action")), :success)
    end
    respond_to do |format|
      format.html { redirect_to aypex.edit_admin_promotion_path(@promotion) }
    end
  end

  private

  def load_promotion
    @promotion = current_store.promotions.find(params[:promotion_id])
  end

  def validate_promotion_action_type
    valid_promotion_action_types = Rails.application.config.aypex.promotions.actions.map(&:to_s)
    unless valid_promotion_action_types.include?(params[:action_type])
      dispatch_notice(I18n.t("aypex.admin.invalid_promotion_action"), :error)

      respond_to do |format|
        format.html { redirect_to aypex.edit_admin_promotion_path(@promotion) }
      end
    end
  end
end
