module Aypex
  module Admin
    module PromotionRulesHelper
      def options_for_promotion_rule_types(promotion)
        existing = promotion.rules.map { |rule| rule.class.name }
        rule_names = Rails.application.config.aypex.promotions.rules.map(&:name).reject { |r| existing.include? r }
        options = rule_names.map { |name| [I18n.t("aypex.admin.#{name.demodulize.underscore}"), name] }
        options_for_select(options)
      end
    end
  end
end
