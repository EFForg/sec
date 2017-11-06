class MakeFeaturedContentNullable < ActiveRecord::Migration[5.1]
  def change
    change_column :featured_content, :content_type, :string, null: true
    change_column :featured_content, :content_id, :bigint, null: true

    h = Homepage.take

    while h.featured_article_content.count > 4
      h.featured_article_content.take.destroy
    end

    while h.featured_article_content.count < 4
      h.featured_article_content.create!
    end

    while h.featured_topic_content.count > 4
      h.featured_topic_content.take.destroy
    end

    while h.featured_topic_content.count < 4
      h.featured_topic_content.create!
    end

    while h.featured_material_content.count > 3
      h.featured_material_content.take.destroy
    end

    while h.featured_material_content.count < 3
      h.featured_material_content.create!
    end

    while h.featured_blog_post_content.count > 3
      h.featured_blog_post_content.take.destroy
    end

    while h.featured_blog_post_content.count < 3
      h.featured_blog_post_content.create!
    end

  end
end
