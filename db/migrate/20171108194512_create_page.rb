class CreatePage < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string :name, null: false
      t.text :body
      t.string :slug

      t.index :name, unique: true
      t.index :slug, unique: true

      t.timestamps
    end

    add_reference :managed_content, :page, foreign_key: true

    reversible do |dir|
      dir.up do
        credits_page = Page.create!(name: "credits")
        ManagedContent.find_or_create_by!(region: "credits").update!(page: credits_page)
      end
    end
  end
end
