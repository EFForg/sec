class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Sharing

  def dismiss_modal
    if params[:dismiss]
      session[:dismissed_modals] ||= []
      session[:dismissed_modals] << params[:modal_name]
    end

    respond_to do |format|
      format.js{ head :ok }
      format.html{ redirect_back fallback_location: root_path }
    end
  end

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  include BreadcrumbsHelper::ControllerMethods
end
