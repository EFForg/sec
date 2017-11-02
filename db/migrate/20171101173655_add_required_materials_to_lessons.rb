class AddRequiredMaterialsToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :required_materials, :text
    LessonResource.where(resource_type: "Material").delete_all
  end
end
