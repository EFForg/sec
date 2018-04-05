module CacheUpdates
  extend ActiveSupport::Concern

  included do
    after_action :queue_site_rebuild if Rails.env.production?
  end

  def queue_site_rebuild
    if request.method == "POST"
      GenerateStaticSite.perform_later(false)
    end
  end
end
