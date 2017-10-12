module Publishing
  extend ActiveSupport::Concern

  included do
    scope :published, ->{ where("published_at IS NOT NULL") }
  end

  def published?
    published_at.present?
  end

  def unpublished?
    !published?
  end
end
