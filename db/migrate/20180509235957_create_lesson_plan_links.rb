class CreateLessonPlanLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :lesson_plan_links do |t|
      t.references :lesson_plan
      t.string :key
      t.text :lesson_ids, array: true, default: []
    end
  end
end
