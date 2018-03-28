class AddPdfFileToLessonPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :lesson_plans, :pdf_file, :string
    add_column :lesson_plans, :pdf_file_updated_at, :datetime
  end
end
