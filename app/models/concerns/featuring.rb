module Featuring
  extend ActiveSupport::Concern

  included do
    has_one :featured_content, as: :content
    has_one :homepage, through: :featured_content

    after_save :touch_homepage
  end

  def touch_homepage
    homepage.try(:touch)
  end
end
