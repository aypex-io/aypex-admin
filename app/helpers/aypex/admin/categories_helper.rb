module Aypex
  module Admin
    module CategoriesHelper
      def category_path(category)
        category.ancestors.reverse.collect(&:name).join(" >> ")
      end
    end
  end
end
