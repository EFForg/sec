class RestorePublishedAtToLessons < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.down{ Lesson.where("published_at IS NULL").destroy_all }
    end

    add_column :lessons, :published_at, :datetime

    reversible do |dir|
      dir.up do
        Topic.find_each do |topic|
          topic.admin_lessons.update_all(published_at: Time.now)

          Lesson::LEVELS.each_key do |level_id|
            topic.admin_lessons.find_or_create_by!(level_id: level_id)
          end
        end
      end
    end
  end
end
