class PublishEverything < ActiveRecord::Migration[5.1]
  def up
    Article.find_each(&:publish!)
    Topic.find_each(&:publish!)
    Lesson.find_each(&:publish!)
    # Blog posts will already be published
  end

  def down
  end
end
