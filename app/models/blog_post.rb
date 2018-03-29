class BlogPost < ApplicationRecord
  include FriendlyLocating

  acts_as_taggable

  include Publishing
  include Featuring

  def self._to_partial_path
    "blog/blog_post"
  end
end
