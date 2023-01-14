module Aypex
  module Admin
    class ClassificationsController < ResourceController
      private

      def load_resource
        @object ||= Classification.find_by(category_id: params[:category_id], product_id: params[:product_id])
      end
    end
  end
end
