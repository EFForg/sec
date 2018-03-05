module GlossaryHelper
  DEFAULT_OPTIONS = {once: true}.freeze

  def link_glossary_terms(doc, options = DEFAULT_OPTIONS)
    @_glossary_pattern ||=
      begin
        @_glossary = {}

        names = []
        GlossaryTerm.all.each do |term|
          term.names.map(&:downcase).each do |name|
            @_glossary[name] = term
          end

          names.concat(term.names)
        end

        names.sort.reverse.map do |name|
          Regexp.escape(name.downcase)
        end.join("|")
      end

    doc.traverse do |child|
      next unless child.name == "text" && glossary_context?(child)

      found, es = replace_glossary_terms(
        doc, child.content,
        @_glossary.dup, @_glossary_pattern
      )
      child.swap(Nokogiri::XML::NodeSet.new(doc.document, es))

      if options[:once]
        @_glossary.delete_if{ |_, term| found.include?(term) }
      end
    end
  end

  def cache_key_for_glossary
    @cache_key_for_glossary ||= GlossaryTerm.all.cache_key
  end

  private

  def glossary_context?(context)
    required_context = ["p", "li"]
    excluded_contexts = ["a"]

    context.ancestors.map do |node|
      return false if excluded_contexts.include?(node.name)

      required_context.include?(node.name)
    end.any?
  end


  def replace_glossary_terms(doc, sample, map, pattern)
    found, elements = [], []

    while match = sample.match(/\b(#{pattern})\b/i)
      item = match[0]
      break if item.empty?

      if term = map.delete(item.downcase)
        found << term
        elements << Nokogiri::XML::Text.new(match.pre_match, doc)
        elements << create_glossary_link(doc, term, item)
      else
        elements << Nokogiri::XML::Text.new(match.pre_match + item, doc)
      end
      sample = match.post_match
    end

    elements << Nokogiri::XML::Text.new(sample, doc)

    [found, elements]
  end

  def create_glossary_link(doc, term, content)
    toggle = "dropdown-#{doc.search("//a[class='glossary-term']").count}"

    Nokogiri::XML::Element.new("a", doc).tap do |link|
      link["href"] = glossary_path(term)
      link["class"] = "glossary-term"
      link["data-toggle"] = toggle
      link.content = content

      img = Nokogiri::XML::Element.new("img", doc)
      img["src"] = image_path("info.png")
      link.add_child(img)

      pane = Nokogiri::XML.fragment(
        File.open(Rails.root.join("app/views/glossary/_tooltip.html.erb")).read
      )
      pane.children.first["id"] = toggle
      link.add_child(pane)
    end
  end
end
