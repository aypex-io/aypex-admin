module Aypex
  module Admin
    class ReturnItemsController < ResourceController
      def location_after_save
        aypex.edit_admin_order_customer_return_path(@return_item.customer_return.order, @return_item.customer_return)
      end
    end
  end
end
