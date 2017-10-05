module BreadcrumbsHelper
  def render_breadcrumbs
    breadcrumbs.each_with_index.map do |page, i|
      (i.zero? ? '' : ' > ') + 
        content_tag(:span, class: "crumb") {
          link_to page[0], page[1]
        }
    end.join.html_safe
  end

  def breadcrumb_names
    breadcrumbs.map(&:first)
  end

  module ControllerMethods
    extend ActiveSupport::Concern

    included do
      helper_method :breadcrumbs
    end

    def breadcrumbs(*pages)
      @breadcrumbs ||= []
      Array(pages).each do |page|
        if page.is_a?(Hash)
          page.each do |name, url|
            @breadcrumbs.push([name, url])
          end
        else
          @breadcrumbs.push([page, nil])
        end
      end
      @breadcrumbs
    end

    class_methods do
      def breadcrumbs(*pages)
        before_action ->{ helpers.breadcrumbs(*pages) }
      end

      def routes
        Rails.application.routes.url_helpers
      end
    end
  end
end
