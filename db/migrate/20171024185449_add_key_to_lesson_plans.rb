class AddKeyToLessonPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :lesson_plans, :key, :string
  end
end
