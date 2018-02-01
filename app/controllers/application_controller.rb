class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Sharing

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  include BreadcrumbsHelper::ControllerMethods
end
