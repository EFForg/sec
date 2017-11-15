class AddPublishedToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :published, :boolean,
               null: false, default: false

    reversible do |dir|
      dir.up { Material.update_all(published: true) }
    end
  end
end
