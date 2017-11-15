class AddIconIdToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :icon_id, :bigint
    remove_column :topics, :icon
  end
end
