class AddSlugToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :slug, :string
    add_index :articles, :slug, unique: true

    reversible do |dir|
      dir.up do
        Article.all.find_each(&:save)
      end
    end
  end
end
