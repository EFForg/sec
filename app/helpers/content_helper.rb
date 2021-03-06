module ContentHelper
  def allowed_tags_for_preview
    %w(b strong i em u s strike del p)
  end

  def preview(object, length: 500, allowed_tags: allowed_tags_for_preview)
    if object.respond_to?(:summary?) && object.summary?
      html = object.summary
    elsif object.respond_to?(:body)
      html = object.body
    else
      html = object.description
    end

    doc = Nokogiri::HTML.fragment(html)
    doc.css(".pull-quote").each(&:remove)
    html = doc.to_html

    html = truncate(sanitize(html, tags: allowed_tags),
                    length: length, escape: false, separator: /\s/)

    doc = Nokogiri::HTML.fragment(html)
    doc.to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def html(html, new_tab_for_all_links: true, glossary: nil)
    if html
      capture do
        cache_if(glossary, glossary && cache_key_for_html(html)) do
          doc = Nokogiri::HTML.fragment(html)
          process_text(doc)
          process_lists(doc)
          process_links(doc, new_tab_for_all_links)
          link_glossary(doc, glossary) if glossary

          r = doc.to_html.html_safe # rubocop:disable Rails/OutputSafety
          concat(r)
        end
      end
    end
  end

  def tags(object, url_helper)
    url_base = breadcrumbs[-2]
    links = object.tags.map do |tag|
      link_to tag.name, send(url_helper, tag: tag.name)
    end
    safe_join(links)
  end

  def content_type(content)
    case content
    when Article
      "Security Education 101"
    when Topic
      "Lesson"
    else
      content.class.name.titleize
    end
  end

  def markdown(html)
    ReverseMarkdown.convert(self.html(html), unknown_tags: :bypass)
  end

  private

  def process_links(doc, new_tab_for_all_links)
    doc.css("a[href]").each do |link|
      uri = URI(link["href"])
      is_external = uri.host && uri.host != request.host

      if is_external
        link["target"] ||= "_blank"
        link["class"] = %(#{link["class"]} external)
      end

      if new_tab_for_all_links
        link["target"] ||= "_blank"
      end
    end if request
  end

  def process_text(doc)
    doc.traverse do |node|
      node.remove if node.text? && node.text !~ /[^\r\n\t]/
    end
  end

  def process_lists(doc)
    doc.css("li > p").each do |p|
      p.replace(p.children[0]) if p.children.size == 1
    end
  end

  def link_glossary(doc, options)
    if options == true
      options = GlossaryHelper::DEFAULT_OPTIONS
    end

    link_glossary_terms(doc, options)
  end

  def cache_key_for_html(html)
    [cache_key_for_glossary, "html/#{Digest::SHA256.hexdigest(html)}"]
  end
end
