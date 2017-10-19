class SearchController < ApplicationController
  def index
    @results = PgSearch.multisearch(params[:q]).page(params[:page])
    respond_to do |format|
      format.html
    end
  end
end
