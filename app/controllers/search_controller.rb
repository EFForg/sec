class SearchController < ApplicationController
  def results
    @results = PgSearch.multisearch(params[:q]).
               preload(:searchable).page(params[:page])

    respond_to do |format|
      format.html
    end
  end
end
