class AddBodyToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :body, :text, null: false
    add_column :blog_posts, :original_url, :string
  end
end
