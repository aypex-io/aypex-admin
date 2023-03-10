class Aypex::Admin::PromotionRulesController < Aypex::Admin::BaseController
  before_action :load_promotion, only: [:create, :destroy, :product_options, :get_product_option_values]
  before_action :validate_promotion_rule_type, only: :create

  def create
    @promotion_rule = @promotion_rule_type.new(promotion_rule_params)
    @promotion_rule.promotion = @promotion
    if @promotion_rule.save
      dispatch_notice(I18n.t("aypex.admin.successfully_created", resource: I18n.t("aypex.admin.promotion_rule")), :success)
    end
    respond_to do |format|
      format.html { redirect_to aypex.edit_admin_promotion_path(@promotion) }
    end
  end

  def destroy
    @promotion_rule = @promotion.promotion_rules.find(params[:id])
    if @promotion_rule.destroy
      dispatch_notice(I18n.t("aypex.admin.successfully_removed", resource: I18n.t("aypex.admin.promotion_rule")), :success)
    end
    respond_to do |format|
      format.html { redirect_to aypex.edit_admin_promotion_path(@promotion) }
    end
  end

  def get_product_option_values
    @promotion_rule ||= @promotion.promotion_rules.find(params[:promotion_rule_id])
    product_ids = @promotion_rule.preferred_eligible_values.keys

    @products = Aypex::Product.find(product_ids)
  end

  def product_options
    @stream_id = params[:stream_id]
    @product = Aypex::Product.find(params[:product_id])
    @product_options = @product.all_option_values
    @promotion_rule = @promotion.promotion_rules.find(params[:promotion_rule_id])
  end

  private

  def load_promotion
    @promotion = current_store.promotions.find(params[:promotion_id])
  end

  def validate_promotion_rule_type
    requested_type = params[:promotion_rule].delete(:type)
    promotion_rule_types = Rails.application.config.aypex.promotions.rules
    @promotion_rule_type = promotion_rule_types.detect do |klass|
      klass.name == requested_type
    end
    unless @promotion_rule_type
      dispatch_notice(I18n.t("aypex.admin.invalid_promotion_rule"), :error)

      respond_to do |format|
        format.html { redirect_to aypex.edit_admin_promotion_path(@promotion) }
      end
    end
  end

  def promotion_rule_params
    params[:promotion_rule].permit!
  end
end
