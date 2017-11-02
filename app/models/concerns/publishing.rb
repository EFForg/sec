module Publishing
  extend ActiveSupport::Concern

  included do
    scope :published, ->{ where.not(published_at: nil) }
  end

  def published?
    published_at.present?
  end

  def unpublished?
    !published?
  end

  def published=(x)
    if x && x != "false"
      assign_attributes(published_at: Time.now) unless published?
    else
      assign_attributes(published_at: nil)
    end
  end

  def publish
    touch(:published_at)
  end

  def unpublish
    update(published_at: nil)
  end
end
