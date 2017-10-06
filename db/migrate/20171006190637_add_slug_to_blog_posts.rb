class AddSlugToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :slug, :string
    add_index :blog_posts, :slug, unique: true

    reversible do |dir|
      dir.up do
        BlogPost.all.find_each(&:save)
      end
    end
  end
end
