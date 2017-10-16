class AddDescriptionToTopic < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :description, :text
  end
end
