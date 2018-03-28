
module ShareLinkHelper
  def share_link(type)
    fixed_type = type.to_s.gsub(/\W/, "")
    attrs = { class: fixed_type.to_s, target: "_blank" }
    link_to send("#{fixed_type}_share_url"), attrs do
      content_tag(:i) +
      content_tag(:span) {
        "Share on #{type.to_s.capitalize}"
      }
    end
  end

  def twitter_share_url
    status = "#{page_title} #{url_for_share}"
    "https://twitter.com/intent/tweet?status=#{u(status)}"
  end

  def google_share_url
    "https://plus.google.com/share?url=#{u(url_for_share)}"
  end

  def facebook_share_url
    "https://www.facebook.com/sharer/sharer.php?u=#{u(url_for_share)}&display=popup"
  end

  def url_for_share
    request.original_url
  end
end
