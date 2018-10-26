class AddThirdPartyToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :third_party, :boolean, null: false, default: true

    reversible do |dir|
      dir.up { Material.update_all(third_party: false) }
    end
  end
end
