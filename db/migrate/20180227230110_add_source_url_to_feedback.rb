class AddSourceUrlToFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedback, :source_url, :string
  end
end
