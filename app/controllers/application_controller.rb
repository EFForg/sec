class ApplicationController < ActionController::Base
  include RequestOriginValidation
  include Sharing

  protect_from_forgery with: :exception

  before_action :set_locale

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

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  include BreadcrumbsHelper::ControllerMethods
end
