class AddPositionToLessonPlanLesson < ActiveRecord::Migration[5.1]
  def change
    add_column :lesson_plan_lessons, :position, :integer, default: 0, null: false
  end
end
