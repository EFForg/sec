class AddPublishedAtToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :published_at, :datetime
  end
end
