class InitializeMultisearchTable < ActiveRecord::Migration[5.1]
  def change
    Article.find_each(&:save)
    BlogPost.find_each(&:save)
    Topic.find_each(&:save)
  end
end
