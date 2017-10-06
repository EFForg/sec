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

    blog_post = BlogPost.find_or_initialize_by(original_url: url)
    blog_post.update!(
      name: title,
      body: body,
      published_at: published
    )
  end
end
