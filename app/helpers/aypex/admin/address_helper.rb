module Aypex
  module Admin
    module AddressHelper
      def state_label(country)
        case country.iso3
        when "ARE"
          I18n.t("aypex.admin.emirate")
        when "AUS"
          I18n.t("aypex.admin.state_territory")
        else
          I18n.t("aypex.admin.state")
        end
      end

      def zipcode_label(country)
        case country.iso3
        when "GBR"
          I18n.t("aypex.admin.post_code")
        when "CAN"
          I18n.t("aypex.admin.post_code")
        when "AUS"
          I18n.t("aypex.admin.post_code")
        else
          I18n.t("aypex.admin.zipcode")
        end
      end
    end
  end
end
