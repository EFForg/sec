class RemoveKeyFromLessonPlan < ActiveRecord::Migration[5.1]
  def change
    remove_column :lesson_plans, :key, :string
  end
end
