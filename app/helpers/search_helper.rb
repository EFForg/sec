module SearchHelper
  def cache_key_for_search(results)
    [PgSearch::Document.all.cache_key,
     results.current_page,
     params[:q]]
  end
end
