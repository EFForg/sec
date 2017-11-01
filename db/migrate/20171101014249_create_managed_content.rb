class CreateManagedContent < ActiveRecord::Migration[5.1]
  def change
    create_table :managed_content do |t|
      t.string :region, null: false
      t.text :body, null: false, default: ""

      t.index :region, unique: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        ManagedContent.create!(region: "credits")
      end
    end
  end
end
