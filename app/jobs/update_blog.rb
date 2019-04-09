require "rss"

class UpdateBlog < ApplicationJob
  queue_as :blog

  include BlogHelper

  # Allow optional "alt" attribute on the Enclosure element.
  # This isn't part of the RSS standard, but Drupal includes it.
  RSS::Rss::Channel::Item::Enclosure.install_get_attribute("alt", "", false)

  def perform
    rss = HTTParty.get("https://www.eff.org/deeplinks.xml?field_issue_tid=11461")
    feed = RSS::Parser.parse(rss)

    new_blog_posts = 0
    feed.items.each do |update|
      doc = Nokogiri::HTML.fragment(update.description)
      rebase_blog_post(doc)

      authorship = update.dc_creators.map(&:content)
      authorship[-1].prepend("and ") if authorship.size > 2
      authors = authorship.join(authorship.size > 2 ? ", " : " and ")
      authors = Nokogiri::HTML.fragment(authors).to_s

      blog_post = BlogPost.find_or_initialize_by(original_url: update.link)
      blog_post.update!(
        original_url: update.link,
        name: update.title,
        authorship: authors.presence,
        image_url: update.enclosure.try(:url),
        image_alt: update.enclosure.try(:alt),
        body: doc.to_html,
        published_at: update.pubDate,
        published: blog_post.persisted? ? blog_post.published : true
      )
    end
  end
end
