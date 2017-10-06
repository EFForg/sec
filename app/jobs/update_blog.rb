require "rss"

class UpdateBlog < ApplicationJob
  queue_as :blog

  include BlogHelper

  def perform
    rss = HTTParty.get("https://www.eff.org/rss/updates.xml")
    feed = RSS::Parser.parse(rss)

    new_blog_posts = 0
    feed.items.each do |update|
      unless BlogPost.where(original_url: update.link).exists?
        doc = Nokogiri::HTML.fragment(update.description)
        rebase_blog_post(doc)

        BlogPost.create!(
          original_url: update.link,
          name: update.title,
          body: doc.to_html,
          published_at: update.pubDate
        )

        new_blog_posts += 1
      end
    end

    new_blog_posts
  end
end
