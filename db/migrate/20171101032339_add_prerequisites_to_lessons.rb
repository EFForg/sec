class AddPrerequisitesToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :prerequisites, :text
    LessonResource.where(resource_type: "Lesson").delete_all
  end
end
