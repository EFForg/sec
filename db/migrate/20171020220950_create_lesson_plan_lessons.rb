class CreateLessonPlanLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lesson_plan_lessons do |t|
      t.integer :lesson_plan_id, null: false
      t.integer :lesson_id, null: false

      t.timestamps
    end
  end
end
