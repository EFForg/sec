class CreateLessonResources < ActiveRecord::Migration[5.1]
  def change
    create_table :lesson_resources do |t|
      t.integer :lesson_id, null: false
      t.references :content, polymorphic: true, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
