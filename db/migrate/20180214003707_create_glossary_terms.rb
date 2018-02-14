class CreateGlossaryTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :glossary_terms do |t|
      t.string :name, null: false
      t.text :body, null: false, default: ""
      t.string :slug

      t.text :synonyms, array: true, default: []

      t.timestamps
    end
  end
end
