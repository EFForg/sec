module ContentHelper
  def allowed_tags_for_preview
    %w(a b strong i em u s strike del p)
  end

  def allowed_tags
    other_tags = %w(h2 h3 h4 ul ol li img blockquote code pre)
    allowed_tags_for_preview + other_tags
  end

  def preview(html)
    html = truncate(sanitize(html, tags: allowed_tags_for_preview),
                    length: 500, escape: false)

    Nokogiri::HTML.fragment(html).to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def tags(object)
  end
end
