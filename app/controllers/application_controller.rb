class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  include BreadcrumbsHelper::ControllerMethods

  protected

  if Rails.application.config.action_controller.default_url_options[:script_name].present?
    def url_options
      super.merge(
        script_name: Rails.application.config.action_controller.default_url_options[:script_name]
      )
    end
  end
end
