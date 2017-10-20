class AddAuthorsToContent < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :authorship, :string
    add_column :blog_posts, :authorship, :string
  end
end
