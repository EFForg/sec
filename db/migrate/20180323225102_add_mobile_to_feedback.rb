class AddMobileToFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedback, :mobile, :boolean, null: false, default: false
  end
end
