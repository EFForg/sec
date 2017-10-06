module ContentHelper
  def preview(html)
    allowed_tags = %w(a b strong i em u s strike del)
    html = truncate(sanitize(html, tags: allowed_tags),
                    length: 500, escape: false)

    Nokogiri::HTML.fragment(html).to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def tags(object)
  end
end
