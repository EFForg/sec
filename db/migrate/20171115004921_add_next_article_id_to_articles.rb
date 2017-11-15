class AddNextArticleIdToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :next_article_id, :bigint
  end
end
