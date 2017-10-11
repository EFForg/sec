module ContentHelper
  def allowed_tags
    allowed_tags = %w(a b strong i em u s strike del p)
  end

  def preview(html)
    html = truncate(sanitize(html, tags: allowed_tags),
                    length: 500, escape: false)

    Nokogiri::HTML.fragment(html).to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def tags(object)
  end
end
