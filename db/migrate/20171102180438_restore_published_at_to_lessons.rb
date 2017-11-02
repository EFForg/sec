class RestorePublishedAtToLessons < ActiveRecord::Migration[5.1]
  def up
    add_column :lessons, :published_at, :datetime

    Topic.find_each do |topic|
      topic.admin_lessons.update_all(published_at: Time.now)

      Lesson::LEVELS.each_key do |level_id|
        topic.admin_lessons.find_or_create_by!(level_id: level_id)
      end
    end
  end

  def down
    Lesson.where("published_at IS NULL").destroy_all

    remove_column :lessons, :published_at, :datetime
  end
end
