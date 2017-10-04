class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :name, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
