class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :breadcrumbs

  protected

  def self.breadcrumbs(*pages)
    before_action ->{ helpers.breadcrumbs(*pages) }
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

  def self.routes
    Rails.application.routes.url_helpers
  end
end
