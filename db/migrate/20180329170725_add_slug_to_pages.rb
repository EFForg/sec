class AddSlugToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :slug, :string
    add_index :pages, :slug, unique: true

    reversible do |dir|
      dir.up do
        Page.all.find_each(&:save)
      end
    end
  end
end
