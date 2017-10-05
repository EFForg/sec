class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|
      t.string :name, null: false, default: ""
      t.text :body, null: false, default: ""

      t.attachment :attachment

      t.timestamps
    end
  end
end
