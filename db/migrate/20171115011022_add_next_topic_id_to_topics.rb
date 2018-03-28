class AddNextTopicIdToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :next_topic_id, :bigint
  end
end
