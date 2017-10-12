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

  def published=(x)
    if x && x != 'false'
      assign_attributes(published_at: Time.now)
    else
      assign_attributes(published_at: nil)
    end
  end

  def publish!
    touch(:published_at)
  end
end
