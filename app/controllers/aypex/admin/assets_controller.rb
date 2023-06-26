module Aypex
  module Admin
    class AssetsController < ResourceController
      def manager
        @collection = collection
        @target ||= find_target_resource
        @object ||= @target.build_asset
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
