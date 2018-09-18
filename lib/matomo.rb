module Matomo
  ARTICLES_SUBTABLE = 1
  LESSON_TOPICS_SUBTABLE = 5

  def self.top_articles
    return @top_articles if @top_articles
    resp = get({
      method: "Actions.getPageUrls",
      idSubtable: ARTICLES_SUBTABLE,
    })
    if resp.response.code == "200"
      @top_articles = resp
    else
      []
    end
  end

  def self.top_lesson_topics
    return @top_lesson_topics if @top_lesson_topics
    resp = get({
      method: "Actions.getPageUrls",
      idSubtable: LESSON_TOPICS_SUBTABLE,
    })
    if resp.response.code == "200"
      @top_lesson_topics = resp
    else
      []
    end
  end

  def self.top_referrers
    return @top_referrers if @top_referrers
    resp = get({
      method: "Referrers.getAll"
    })

    if resp.response.code == "200"
      @top_referrers = resp
    else
      []
    end
  end

  def self.visits_graph_url
    base_url + "?" + default_params.merge({
      method: "ImageGraph.get",
      apiModule: "VisitsSummary",
      apiAction: "get",
      token_auth: "anonymous",
      width: 800,
      height: 400,
      period: "day",
      date: "last30",
    }).to_param
  end

  def self.top_pages_url
    "#{base_url}/index.php?module=CoreHome&action=index&"\
    "idSite=#{site_id}&period=month&date=yesterday&updated=1#?"\
    "idSite=#{site_id}&period=month&date=#{Date.today.strftime("%Y-%m-%d")}"\
    "&category=General_Actions&subcategory=General_Pages"
  end

  def self.top_referrers_url
    "https://anon-stats.eff.org/index.php?module=CoreHome&action=index&"\
    "idSite=#{site_id}&period=day&date=yesterday&updated=1#?"\
    "idSite=#{site_id}&period=month&date=#{Date.today.strftime("%Y-%m-%d")}"\
    "&category=Referrers_Referrers&subcategory=Referrers_WidgetGetAll"
  end

  private

  def self.get(params)
    url = base_url + "?" + default_params.merge(params).to_param
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
      period: "range",
      date: "previous30",
      filter_limit: 5
    }
  end
end
