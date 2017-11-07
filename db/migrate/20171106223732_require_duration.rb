class RequireDuration < ActiveRecord::Migration[5.1]
  def change
    change_column :lessons, :duration, :integer, null: false, default: 0
  end
end
