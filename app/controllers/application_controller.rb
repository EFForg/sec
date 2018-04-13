class ApplicationController < ActionController::Base
  include RequestOriginValidation
  include Sharing

  protect_from_forgery with: :exception

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  include BreadcrumbsHelper::ControllerMethods
end
