class CreateArticleSections < ActiveRecord::Migration[5.1]
  def change
    create_table :article_sections do |t|
      t.string :name, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_column :articles, :section_id, :bigint
    add_column :articles, :section_position, :integer, null: false, default: 0
  end
end
