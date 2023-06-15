module Aypex
  module Admin
    module NavigationHelper
      # Makes an admin navigation tab (<li> tag) that links to a routing resource under /admin.
      # The arguments should be a list of symbolized controller names that will cause this tab to
      # be highlighted, with the first being the name of the resource to link (uses URL helpers).
      #
      # Option hash may follow. Valid options are
      #   * :label to override link text, otherwise based on the first resource name (translated)
      #   * :route to override automatically determining the default route
      #   * :match_path as an alternative way to control when the tab is active, /products would
      #     match /admin/products, /admin/products/5/variants etc.  Can be a String or a Regexp.
      #     Controller names are ignored if :match_path is provided.
      #
      # Example:
      #   # Link to /admin/orders, also highlight tab for ProductsController and ShipmentsController
      #   tab :orders, :products, :shipments

      ICON_SIZE = 16
      MENU_ICON_SIZE = 18

      def accounts_menu_active?
        @menu_panel_kind == "account"
      end

      def main_menu_active?
        @menu_panel_kind == "main"
      end

      def settings_menu_active?
        @menu_panel_kind == "settings"
      end

      def store_switcher_menu_active?
        @menu_panel_kind == "store_switcher"
      end

      def tab(*args)
        options = {label: args.first.to_s}

        # Return if resource is found and user is not allowed to :admin
        return "" if (klass = klass_for(args.first.to_s)) && cannot?(:admin, klass)

        options = options.merge(args.pop) if args.last.is_a?(Hash)
        options[:route] ||= "admin_#{args.first}"

        destination_url = options[:url] || aypex.send("#{options[:route]}_path")

        titleized_label = if options[:do_not_titleize] == true
          options[:label]
        else
          # i18n-tasks-use I18n.t('aypex.admin.applications')
          I18n.t(options[:label], default: options[:label], scope: [:aypex, :dash, :tab]).titleize
        end

        css_classes = ["sidebar-menu-item d-block w-100 position-relative rounded"]

        if (selected = options[:selected]).nil?
          selected = if options[:match_path].is_a? Regexp
            request.fullpath =~ options[:match_path]
          elsif options[:match_path]
            request.fullpath.starts_with?("#{aypex.admin_path}#{options[:match_path]}")
          else
            args.include?(controller.controller_name.to_sym)
          end
        end

        link = if options[:icon]
          link_to_with_icon(titleized_label, destination_url, {class: "w-100 px-3 py-2 d-flex align-items-center", icon: options[:icon], icon_class: "me-2"})
        else
          link_to(titleized_label, destination_url, {class: "sidebar-submenu-item w-100 py-2 py-md-1 d-block ps-3 rounded"})
        end

        css_classes << "selected" if selected
        controller_name = "menu" if selected

        css_classes << options[:css_class] if options[:css_class]
        content_tag("li", link, class: css_classes.join(" "), data: {controller: controller_name})
      end

      # Single main menu item
      def main_menu_item(text, url: nil, icon: nil)
        link_to url, data: {bs_toggle: "collapse"}, class: "d-flex w-100 px-3 py-2 position-relative align-items-center" do
          aypex_admin_svg_tag(icon, class: "me-2", size: "#{MENU_ICON_SIZE}px * #{MENU_ICON_SIZE}px") +
            content_tag(:span, raw(" #{text}")) +
            aypex_admin_svg_tag("chevron-up.svg", class: "drop-menu-indicator position-absolute", size: "#{MENU_ICON_SIZE}px * #{MENU_ICON_SIZE}")
        end
      end

      # Main menu tree menu
      def main_menu_tree(text, icon: nil, sub_menu: nil, url: "#")
        content_tag :li, class: "d-block w-100 rounded position-relative" do
          main_menu_item(text, url: url, icon: icon) +
            render(partial: "aypex/admin/shared/sub_menu/#{sub_menu}")
        end
      end

      # Finds class for a given symbol / string
      #
      # Example :
      # :products returns Aypex::Product
      # :my_products returns MyProduct if MyProduct is defined
      # :my_products returns My::Product if My::Product is defined
      # if cannot constantize it returns nil
      # This will allow us to use cancan abilities on tab
      def klass_for(name)
        model_name = name.to_s

        ["Aypex::#{model_name.classify}", model_name.classify, model_name.tr("_", "/").classify].find(&:safe_constantize).try(:safe_constantize)
      end

      def link_to_edit(resource, options = {})
        url = options[:url] || edit_object_url(resource)
        name = options[:name] || I18n.t("aypex.admin.edit")

        options[:no_text] ||= true
        options[:icon] = "pen.svg"
        options[:class] ||= "btn btn-aypex btn-sm icon-edit"

        link_to_with_icon(name, url, options.except(:url))
      end

      def link_to_clone(resource, options = {})
        url = options[:url] || clone_object_url(resource)
        name = options[:name] || I18n.t("aypex.admin.clone")

        options[:no_text] ||= true
        options[:class] ||= "btn btn-aypex btn-sm icon-clone"
        options[:icon] = "clone.svg"
        options[:data] = {turbo_method: :post, turbo_confirm: I18n.t("aypex.admin.are_you_sure_you_want_to", action: name, resource: aypex_humanize_type(resource.class.name))}

        link_to_with_icon(name, url, options)
      end

      def link_to_delete(resource, options = {})
        url = options[:url] || object_url(resource)
        name = options[:name] || I18n.t("aypex.admin.delete")

        options[:no_text] ||= true
        options[:class] ||= "btn btn-sm btn-danger icon-delete"
        options[:icon] = "x-lg.svg"
        options[:data] = {turbo_method: :delete, turbo_confirm: I18n.t("aypex.admin.are_you_sure_you_want_to", action: name, resource: aypex_humanize_type(resource.class.name))}

        link_to_with_icon(name, url, options.except(:url))
      end

      def link_to_with_icon(name, url, html_options = {})
        html_options[:class] ||= ""
        name = html_options[:no_text] ? "" : content_tag(:span, name)

        if html_options[:icon]
          icon_class = html_options[:no_text] ? "" : "me-md-1"
          html_options[:icon_size] ||= "#{ICON_SIZE}px * #{ICON_SIZE}px"
          icon = aypex_admin_svg_tag(html_options[:icon], class: "#{icon_class} #{html_options[:icon_class]}", size: html_options[:icon_size])
          name = "#{icon} #{name}"
        end

        link_to name.html_safe, url, html_options.except(:icon, :icon_class, :icon_size, :no_text)
      end

      # Override: Add disable_with option to prevent multiple request on consecutive clicks
      def button(text, icon_name = nil, button_type = "submit", html_options = {})
        if icon_name
          icon = aypex_admin_svg_tag(icon_name, class: "svg-icon icon-#{icon_name}", size: "#{ICON_SIZE}px * #{ICON_SIZE}px")
          text = "#{icon} #{text}"
        end

        css_classes = html_options[:class] || "btn-primary "

        button_tag(text.html_safe, html_options.merge(type: button_type, class: "btn #{css_classes}"))
      end

      def breadcrumb_builder(options = {})
        home_page = link_to aypex.admin_root_path do
          aypex_admin_svg_tag "home.svg", size: "20px * 20px", class: "pb-1"
        end

        content = if options[:link_one_uri] && options[:link_two_text]
          content_tag(:li, home_page) +
            content_tag(:li, link_to(options[:link_one_text], options[:link_one_uri])) +
            content_tag(:li, link_to(options[:link_two_text], options[:link_two_uri])) +
            content_tag(:li, link_to(options[:current_page_name], "#"))
        elsif options[:link_one_uri]
          content_tag(:li, home_page) +
            content_tag(:li, link_to(options[:link_one_text], options[:link_one_uri])) +
            content_tag(:li, link_to(options[:current_page_name], "#"))
        else
          content_tag(:li, home_page) +
            content_tag(:li, link_to(options[:current_page_name], "#"))
        end

        ul = content_tag(:ul, content)
        content_tag(:div, ul, class: "oh-crumbs")
      end

      def remote_form_submit_button(resource, form_id = nil, button_text = nil)
        form_id ||= "mainForm"

        if button_text.nil?
          button_text = if resource.persisted?
            I18n.t("aypex.admin.update")
          else
            I18n.t("aypex.admin.create")
          end
        end

        button(button_text, "check-lg.svg", "submit", {form: form_id, class: "btn btn-primary animate__fadeIn animate__animated animate__faster"})
      end

      def active_badge(condition, options = {})
        label = options[:label]
        label ||= condition ? I18n.t("aypex.admin.say_yes") : I18n.t("aypex.admin.say_no")
        css_class = condition ? "rgb-hsl-success" : "rgb-hsl-secondary"

        content_tag(:small, class: "badge rounded-pill #{css_class}") do
          label
        end
      end
    end
  end
end
