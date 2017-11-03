class AddSummaryToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :summary, :text
  end
end
