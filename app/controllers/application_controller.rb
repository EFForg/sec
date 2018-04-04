class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include RequestOriginValidation
  include Sharing

  skip_before_action :verify_authenticity_token, only: :session_data
  before_action :verify_request_origin, only: :session_data

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  def session_data
    render "shared/session_data"
  end

  include BreadcrumbsHelper::ControllerMethods
end
