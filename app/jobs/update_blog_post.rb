class UpdateBlogPost < ApplicationJob
  queue_as :default

  include BlogHelper

  def perform(url)
    html = HTTParty.get(url)
    doc = Nokogiri::HTML(html)

    rebase_blog_post(doc)

    title = doc.css("h1")[0].to_str
    body = doc.css(".node__content")[0].inner_html

    published = doc.css("meta[property$=published_time]")[0]["content"]
    authors = doc.css(".byline").inner_text.split("by", 2)[-1].strip

    blog_post = BlogPost.find_or_initialize_by(original_url: url)
    blog_post.update!(
      name: title,
      body: body,
      authorship: authors.presence,
      published_at: published,
      published: true
    )
  end
end
