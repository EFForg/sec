class SearchController < ApplicationController
  def results
    @results = PgSearch.multisearch(params[:q]).page(params[:page])
  end
end
