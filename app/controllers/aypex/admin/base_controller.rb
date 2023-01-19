module Aypex
  module Admin
    class BaseController < ApplicationController
      include Pagy::Backend

      include Aypex::ControllerHelpers::Auth
      include Aypex::ControllerHelpers::Search
      include Aypex::ControllerHelpers::Store
      include Aypex::ControllerHelpers::StrongParameters
      include Aypex::ControllerHelpers::Locale
      include Aypex::ControllerHelpers::Currency

      respond_to :html

      helper "aypex/base"
      helper "aypex/admin/navigation"
      helper "aypex/locale"
      helper "aypex/currency"

      layout "aypex/layouts/admin"

      before_action :authorize_admin, :load_stores, :load_main_menu_panel

      helper_method :admin_oauth_token, :stream_flash_alert

      def path_for(obj)
        obj.class.name.demodulize.underscore
      end

      protected

      default_form_builder(Aypex::Dash::BootstrapBuilder)

      def action
        params[:action].to_sym
      end

      def authorize_admin
        record = if respond_to?(:model_class, true) && model_class
          model_class
        else
          controller_name.to_sym
        end
        authorize! :admin, record
        authorize! action, record
      end

      def redirect_unauthorized_access
        if try_aypex_current_user
          dispatch_notice(Aypex.t(:authorization_failure), :error)
          redirect_to aypex.admin_forbidden_path
        else
          store_location
          if defined?(aypex.admin_login_path)
            redirect_to aypex.admin_login_path
          elsif respond_to?(:aypex_login_path)
            redirect_to aypex_login_path
          elsif aypex.respond_to?(:root_path)
            redirect_to aypex.root_path
          else
            redirect_to main_app.respond_to?(:root_path) ? main_app.root_path : "/"
          end
        end
      end

      def flash_message_for(object, event_sym, kind = :success)
        resource_desc = object.class.model_name.human
        resource_desc += " \"#{object.name}\"" if (object.persisted? || object.destroyed?) && object.respond_to?(:name) && object.name.present? && !object.is_a?(Aypex::Order)

        dispatch_notice(Aypex.t(event_sym, resource: resource_desc), kind)
      end

      def dispatch_notice(message, kind)
        turbo_frame_id = turbo_frame_request_id || :_top

        flash[:kind] = kind
        flash[:turbo_frame_request_id] = turbo_frame_id
        flash[:message] = message
      end

      def stream_flash_alert(message: I18n.t("aypex.admin.no_message_set"), kind: :success)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.append("FlashAlertsContainer", partial: "aypex/admin/shared/toast", locals: {message: message, kind: kind})
          end
        end
      end

      def stores_scope
        Aypex::Store.accessible_by(current_ability, :show)
      end

      def load_stores
        @stores = stores_scope.order(default: :desc)
      end

      def load_main_menu_panel
        @menu_panel_kind = "main"
      end

      def can_not_transition_without_customer_info
        unless @order.billing_address.present?
          dispatch_notice(Aypex.t(:fill_in_customer_info), :notice)
          redirect_to aypex.edit_admin_order_url(@order)
        end
      end

      def admin_oauth_application
        @admin_oauth_application ||= Aypex::OauthApplication.find_or_create_by!(name: "Admin Panel", scopes: "admin", redirect_uri: "")
      end

      # FIXME: auto-expire this token
      def admin_oauth_token
        user = try_aypex_current_user
        return unless user

        @admin_oauth_token ||= begin
          Aypex::OauthAccessToken.active_for(user).where(application_id: admin_oauth_application.id).last ||
            Aypex::OauthAccessToken.create!(
              resource_owner: user,
              application_id: admin_oauth_application.id,
              scopes: admin_oauth_application.scopes
            )
        end.token
      end
    end
  end
end
