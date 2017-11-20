class DropLessonResources < ActiveRecord::Migration[5.1]
  def change
    drop_table :lesson_resources
  end
end
