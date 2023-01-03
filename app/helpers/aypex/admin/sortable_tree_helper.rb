module Aypex
  module Admin
    module SortableTreeHelper
      def sortable_tree_bar(parent_resource, child_resource)
        partial_name = parent_resource.class.name.demodulize.underscore
        render "aypex/admin/shared/sortable_tree/#{partial_name}", parent_resource: parent_resource, child_resource: child_resource
      end

      def build_sortable_tree(parent_resource, child_resource)
        parent_resource_name = parent_resource.class.name.demodulize.underscore
        child_resource_name = child_resource.class.name.demodulize.underscore
        descendants = []

        unless child_resource.leaf?
          child_resource.children.each do |child_item|
            descendants << build_sortable_tree(parent_resource, child_item) unless child_resource.leaf?
          end
        end

        row = sortable_tree_bar(parent_resource, child_resource)
        container = content_tag(:div, raw(descendants.join), data: {sortable_tree_parent_id_value: child_resource.id})

        content_tag(:div, row + container,
          class: "sortable-tree-item draggable removable-dom-element",
          data: {
            sortable_tree_resource_name_value: child_resource_name.singularize,
            sortable_tree_update_url_value: "/admin/#{parent_resource_name.pluralize}/#{parent_resource.id}/#{child_resource_name.pluralize}/#{child_resource.id}/reposition"
          })
      end
    end
  end
end
