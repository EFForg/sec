class CreateLessonPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :lesson_plans do |t|
      t.integer :lessons_count, null: false, default: 0

      t.timestamps
    end
  end
end
