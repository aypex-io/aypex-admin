module Aypex
  module Admin
    module CustomerReturnsHelper
      def reimbursement_types
        @reimbursement_types ||= Aypex::ReimbursementType.accessible_by(current_ability).active
      end
    end
  end
end
