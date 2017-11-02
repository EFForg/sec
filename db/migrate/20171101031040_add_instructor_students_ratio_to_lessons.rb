class AddInstructorStudentsRatioToLessons < ActiveRecord::Migration[5.1]
  def change
    remove_column :lessons, :instructors
    remove_column :lessons, :students
    add_column :lessons, :instructor_students_ratio, :string
  end
end
