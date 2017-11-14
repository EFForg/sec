class AddRecommendedReadingToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :recommended_reading, :text
  end
end
