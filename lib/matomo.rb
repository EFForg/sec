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
    "#{base_url}/index.php?module=CoreHome&action=index&"\
    "idSite=#{site_id}&period=month&date=yesterday&updated=1#?"\
    "idSite=#{site_id}&period=month&date=#{Date.today.strftime("%Y-%m-%d")}"\
    "&category=General_Actions&subcategory=General_Pages"
  end

  private

  def self.get(params)
    url = base_url + "?" + params.merge(default_params).to_param
    HTTParty.get(url)
  end

  def self.base_url
    "https://anon-stats.eff.org"
  end

  def self.site_id
    ENV["MATOMO_SITE_ID"]
  end

  def self.default_params
    {
      module: "API",
      idSite: site_id,
      format: "JSON",
      period: "month",
      date: "today"
    }
  end
end
