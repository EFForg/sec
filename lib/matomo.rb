module Matomo
  ARTICLES_SUBTABLE = 1
  LESSON_TOPICS_SUBTABLE = 3

  def self.top_articles
    @top_articles ||= get({
      method: "Actions.getPageUrls",
      idSubtable: ARTICLES_SUBTABLE,
      filter_limit: 8
    })
  end

  def self.top_lesson_topics
    @top_lesson_topics ||= get({
      method: "Actions.getPageUrls",
      idSubtable: LESSON_TOPICS_SUBTABLE,
      filter_limit: 8
    })
  end

  def self.pages_url
   "#{base_url}/index.php?module=CoreHome&action=index&idSite=28&period=day&date=yesterday&updated=1#?idSite=28&period=month&date=2018-09-13&category=General_Actions&subcategory=General_Pages"
  end

  private

  def self.get(params)
    url = base_url + "?" + params.merge(default_params).to_param
    HTTParty.get(url)
  end

  def self.base_url
    "https://anon-stats.eff.org"
  end

  def self.default_params
    {
      module: "API",
      idSite: 28,
      format: "JSON",
      period: "month",
      date: "today"
    }
  end
end
