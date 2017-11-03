class AddFlagToContent < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :flag, :string
    add_column :blog_posts, :flag, :string
    add_column :topics, :flag, :string
    add_column :materials, :flag, :string
  end
end
