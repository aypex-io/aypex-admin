module Aypex
  module Admin
    class PrototypesController < ResourceController
      def show
        redirect_to aypex.admin_prototypes_path
      end
    end
  end
end
