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

  private

  def glossary_context?(context)
    required_context = ["p", "li"]
    excluded_contexts = ["a"]

    context.ancestors.map do |node|
      return false if excluded_contexts.include?(node.name)

      required_context.include?(node.name)
    end.any?
  end


  def replace_glossary_terms(doc, text, map, pattern)
    found, elements = [], []
    sample = text

    while match = sample.match(/\b(#{pattern})\b/i)
      break if match[0].empty?

      term = map.delete(match[0].downcase)

      if term
        found << term

        link = Nokogiri::XML::Element.new("a", doc)
        link["href"] = glossary_path(term)
        link["class"] = "glossary-term"
        link.content = match[0]

        img = Nokogiri::XML::Element.new("img", doc)
        img["src"] = image_path("info.png")
        link.add_child(img)

        elements << Nokogiri::XML::Text.new(match.pre_match, doc)
        elements << link
      else
        elements << Nokogiri::XML::Text.new(match.pre_match + match[0], doc)
      end
      sample = match.post_match
    end

    elements << Nokogiri::XML::Text.new(sample, doc)

    [found, elements]
  end
end
