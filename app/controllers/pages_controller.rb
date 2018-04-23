class PagesController < ApplicationController
  def show
    @page = Page.friendly.find(params[:page_id])
  end
end
