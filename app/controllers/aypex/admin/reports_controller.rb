module Aypex
  module Admin
    class ReportsController < Aypex::Admin::BaseController
      class << self
        def available_reports
          @@available_reports
        end

        def add_available_report!(report_key, report_description_key = nil)
          if report_description_key.nil?
            report_description_key = "#{report_key}_description"
          end
          # i18n-tasks-use I18n.t('aypex.admin.sales_total')
          # i18n-tasks-use I18n.t('aypex.admin.sales_total_description')
          @@available_reports[report_key] = {name: I18n.t("aypex.admin.#{report_key}"), description: I18n.t("aypex.admin.#{report_description_key}")}
        end
      end

      def initialize
        super
        ReportsController.add_available_report!(:sales_total)
      end

      def index
        @reports = ReportsController.available_reports
      end

      def sales_total
        params[:q] = {} unless params[:q]

        params[:q][:completed_at_gt] = if params[:q][:completed_at_gt].blank?
          Time.zone.now.beginning_of_month
        else
          begin
            Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day
          rescue
            Time.zone.now.beginning_of_month
          end
        end

        if params[:q] && !params[:q][:completed_at_lt].blank?
          params[:q][:completed_at_lt] = begin
            Time.zone.parse(params[:q][:completed_at_lt]).end_of_day
          rescue
            ""
          end
        end

        params[:q][:s] ||= "completed_at desc"

        @search = scope.complete.ransack(params[:q])
        @orders = @search.result

        @totals = {}
        @orders.each do |order|
          @totals[order.currency] = {item_total: ::Money.new(0, order.currency), adjustment_total: ::Money.new(0, order.currency), sales_total: ::Money.new(0, order.currency)} unless @totals[order.currency]
          @totals[order.currency][:item_total] += order.display_item_total.money
          @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
          @totals[order.currency][:sales_total] += order.display_total.money
        end
      end

      private

      def scope
        current_store.orders.accessible_by(current_ability, :index)
      end

      def model_class
        Aypex::Admin::ReportsController
      end

      @@available_reports = {}
    end
  end
end
