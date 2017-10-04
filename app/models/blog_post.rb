class BlogPost < ApplicationRecord
  def self._to_partial_path
    "blog/blog_post"
  end
end
