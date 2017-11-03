class RenamePublishedAtToPublished < ActiveRecord::Migration[5.1]
  def up
    tables.each do |table|
      add_column table, :published, :boolean,
        null: false, default: false

      execute "UPDATE #{table} SET published = published_at NOTNULL"

      remove_column table, :published_at
    end

    add_column :blog_posts, :published, :boolean,
      null: false, default: false

    execute "UPDATE blog_posts SET published = 't'"
  end

  def down
    tables.each do |table|
      add_column table, :published_at, :datetime

      execute "UPDATE #{table} SET published_at = clock_timestamp() WHERE published"

      remove_column table, :published
    end

    remove_column :blog_posts, :published
  end

  private

  def tables
    [:topics, :lessons, :articles]
  end
end
