class ActiveAdmin::BaseController
  include CacheUpdates

  actions :all, except: [:show]
  after_action :set_flash_header

  def update
    update! do |format|
      format.js { render json: { success: true } }
    end
  end

  def set_flash_header
    if request.xhr?
      response.headers["X-Message"] = flash[:error] unless flash[:error].blank?
      response.headers["X-Message"] = flash[:notice] unless flash[:notice].blank?
      flash.discard
    end
  end
end
