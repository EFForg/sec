module Publishing
  extend ActiveSupport::Concern

  included do
    scope :published, ->{ where("published_at IS NOT NULL") }
  end

  def published?
    not published_at.nil?
  end

  def unpublished?
    not published?
  end
end
