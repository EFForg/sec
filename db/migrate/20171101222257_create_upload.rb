class CreateUpload < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :name
      t.text :description
      t.string :file
      t.references :material
      t.integer :position, default: 0, null: false
      t.timestamps
    end

    remove_column :materials, :attachment, :string
    rename_column :materials, :body, :description
  end
end
