class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :breadcrumbs

  protected

  def self.breadcrumbs(*pages)
    before_action ->{ helpers.breadcrumbs(*pages) }
  end

  def breadcrumbs(*pages)
    @breadcrumbs ||= []
    @breadcrumbs.concat(pages)
  end
end
