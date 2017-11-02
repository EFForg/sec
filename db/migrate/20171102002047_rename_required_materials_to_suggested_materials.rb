class RenameRequiredMaterialsToSuggestedMaterials < ActiveRecord::Migration[5.1]
  def change
    rename_column :lessons, :required_materials, :suggested_materials
  end
end
