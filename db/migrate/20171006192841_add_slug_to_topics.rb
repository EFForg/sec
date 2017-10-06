class AddSlugToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :slug, :string
    add_index :topics, :slug, unique: true

    reversible do |dir|
      dir.up do
        Topic.all.find_each(&:save)
      end
    end
  end
end
