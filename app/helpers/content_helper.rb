module ContentHelper
  def allowed_tags_for_preview
    %w(a b strong i em u s strike del p)
  end

  def preview(html)
    html = truncate(sanitize(html, tags: allowed_tags_for_preview),
                    length: 500, escape: false)

    Nokogiri::HTML.fragment(html).to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def tags(object, url_helper)
    url_base = breadcrumbs[-2]
    links = object.tags.map do |tag|
      link_to tag.name, send(url_helper, tag: tag.name)
    end
    safe_join(links)
  end

  def managed_content(region)
    content = ManagedContent.find_by!(region: region)
    content.body.html_safe
  end
end
