module Publishing
  extend ActiveSupport::Concern

  included do
    scope :published, ->{ where(published: true) }
  end

  def unpublished?
    !published?
  end

  def publish
    update_attribute(:published, true)
  end

  def unpublish
    update_attribute(:published, false)
  end
end
