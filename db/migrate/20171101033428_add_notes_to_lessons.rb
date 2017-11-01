class AddNotesToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :notes, :text
  end
end
