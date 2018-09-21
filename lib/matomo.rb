module Matomo
  class Referrer
    attr_accessor :label, :visits

    def initialize(params)
      @label = params["label"]
      @visits = params["nb_visits"]
      @actions = params["nb_actions"]
    end

    def actions_per_visit
      return 0 unless @actions and @visits
      (@actions/@visits.to_f).round(1)
    end
  end

  class VisitedPage
    attr_accessor :label, :hits, :visits

    def initialize(parent_page, params)
      @parent_page = parent_page
      @label = params["label"].sub!(/^\//, "")
      @hits = params["nb_hits"]
      @visits = params["nb_visits"]
    end

    def path
      "/#{@parent_page}/#{@label}"
    end
  end

  def self.top_referrers
    resp = get({
      method: "Referrers.getAll"
    })
    return [] if resp.response.code != "200"
    resp.map{ |x| Referrer.new(x) }
  end

  def self.get_subtables
    # Get a mapping from resource paths to Matomo page view subtable ids
    resp = get({
      method: "Actions.getPageUrls",
      filter_limit: -1,
    })
    if resp.response.code == "200"
      @subtables = resp.pluck("label", "idsubdatatable").to_h
    else
      @subtables = {}
    end
  end

  def self.method_missing(name, *args)
    # Add top_#{resource} methods to display Matomo page view subtables
    super unless name.to_s.starts_with?("top_")
    get_subtables unless @subtables
    parent_page = name.to_s.sub("top_", "")
    return [] unless @subtables[parent_page]

    resp = get({
      method: "Actions.getPageUrls",
      idSubtable: @subtables[parent_page],
    })
    return [] if resp.response.code != "200"
    resp.map{ |x| VisitedPage.new(parent_page, x) }
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
    }).to_param
  end

  def self.top_pages_url
    base_portal_url+"&category=General_Actions&subcategory=General_Pages"
  end

  def self.top_referrers_url
    base_portal_url+"&category=Referrers_Referrers&subcategory=Referrers_WidgetGetAll"
  end

  private

  def self.get(params)
    url = base_url + "?" + default_params.merge(params).to_param
    HTTParty.get(url)
  end

  def self.base_url
    "https://anon-stats.eff.org"
  end

  def self.base_portal_url
    # Gnarly base url for finding pages on the Matomo web portal
    "#{base_url}/index.php?module=CoreHome&action=index&"\
    "idSite=#{site_id}&period=#{default_params[:period]}&date=#{default_params[:date]}&updated=1#?"\
    "idSite=#{site_id}&period=#{default_params[:period]}&date=#{default_params[:date]}"\
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
      date: "last30",
      filter_limit: 5
    }
  end
end
