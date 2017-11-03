require "rss"

class UpdateBlog < ApplicationJob
  queue_as :blog

  include BlogHelper

  def perform
    rss = HTTParty.get("https://www.eff.org/deeplinks.xml?field_issue_tid=11461")
    feed = RSS::Parser.parse(rss)

    new_blog_posts = 0
    feed.items.each do |update|
      unless BlogPost.where(original_url: update.link).exists?
        doc = Nokogiri::HTML.fragment(update.description)
        rebase_blog_post(doc)

        authorship = update.dc_creators.map(&:content)
        authorship[-1].prepend("and ") if authorship.size > 2
        authors = authorship.join(authorship.size > 2 ? ", " : " and ")

        BlogPost.create!(
          original_url: update.link,
          name: update.title,
          authorship: authors.presence,
          body: doc.to_html,
          published_at: update.pubDate,
          published: true
        )

        new_blog_posts += 1
      end
    end

    new_blog_posts
  end
end
