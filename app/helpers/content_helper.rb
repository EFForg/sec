module ContentHelper
  def preview(html)
    allowed_tags = %w(a b strong i em u s strike del)
    truncate_html(sanitize(html, tags: allowed_tags), length: 500)
  end

  def tags(object)
  end
end
