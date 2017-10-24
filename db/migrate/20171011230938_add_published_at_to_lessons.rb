class AddPublishedAtToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :published_at, :datetime
  end
end
