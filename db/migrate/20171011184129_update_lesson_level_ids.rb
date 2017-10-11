class UpdateLessonLevelIds < ActiveRecord::Migration[5.1]
  def up
    Lesson.update_all("level_id = level_id + 1")
  end

  def down
    Lesson.update_all("level_id = level_id - 1")
  end
end
