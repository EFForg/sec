class AddLessonIdToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :lesson_id, :integer
  end
end
