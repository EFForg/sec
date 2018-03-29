class DeleteBlogPostSearchResults < ActiveRecord::Migration[5.1]
  def up
    PgSearch::Document.where(searchable_type: "BlogPost").destroy_all
  end
end
