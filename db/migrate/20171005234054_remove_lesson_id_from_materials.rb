class RemoveLessonIdFromMaterials < ActiveRecord::Migration[5.1]
  def change
    remove_column :materials, :lesson_id, :integer
  end
end
