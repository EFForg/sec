class PagesController < ApplicationController
  def show
    @page = Page.friendly.find(params[:page_id])
    @page_title = @page.name.capitalize
  end
end
