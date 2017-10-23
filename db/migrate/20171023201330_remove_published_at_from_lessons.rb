class RemovePublishedAtFromLessons < ActiveRecord::Migration[5.1]
  def change
    remove_column :lessons, :published_at, :datetime
  end
end
