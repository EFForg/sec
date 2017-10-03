class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.references :topic
      t.string :name
      t.integer :duration
      t.text :body
      t.timestamps
    end
  end
end
