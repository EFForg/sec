class AddSlugToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :slug, :string

    reversible do |dir|
      dir.up { Material.all.each(&:save) }
    end
  end
end
