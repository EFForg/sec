class AddAttributesToLesson < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :instructors, :integer
    add_column :lessons, :students, :integer
    add_column :lessons, :objective, :text
    add_column :lessons, :level_id, :integer, null: false, default: 0
    remove_column :lessons, :name, :string
  end
end
