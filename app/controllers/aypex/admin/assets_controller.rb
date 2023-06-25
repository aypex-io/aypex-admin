module Aypex
  module Admin
    class AssetsController < ResourceController
      def init_asset_manager
        @object = Aypex::Asset.new
        @collection = collection
        @target ||= find_target_resource
      end

      private

      def find_target_resource
        klass = params[:assets][:viewable_type].constantize
        resource = klass.find(params[:assets][:viewable_id])
        resource.image
      end

      def scope
        current_store.assets
      end
    end
  end
end
