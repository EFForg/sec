module GlossaryHelper
  def link_glossary_terms(doc, options={once: true})
    @_glossary ||= GlossaryTerm.all.to_a

    @_glossary.dup.each do |term|
      doc.traverse do |child|
        if child.name == 'text' && glossary_context?(child)

          es = replace_glossary_term(doc, child.content, term)
          if es
            child.swap(Nokogiri::XML::NodeSet.new(doc.document, es))
            @_glossary.delete(term) if options[:once]
            break
          end
        end
      end
    end
  end

  private

  def glossary_context?(context)
    required_context = ['p', 'li']
    excluded_contexts = ['a']

    context.ancestors.map do |node|
      return false if excluded_contexts.include?(node.name)

      required_context.include?(node.name)
    end.any?
  end

  def replace_glossary_term(doc, text, term)
    pattern = [term.name, *term.synonyms].join("|")
    if match = text.match(/\b(#{pattern})\b/i)
      link = Nokogiri::XML::Element.new("a", doc)
      link["href"] = glossary_path(term)
      link["class"] = "glossary-term"
      link.content = match[0]

      img = Nokogiri::XML::Element.new("img", doc)
      img["src"] = "https://ssd.eff.org/sites/all/themes/ssd/img/info.png"
      link.add_child(img)

      [
        Nokogiri::XML::Text.new(match.pre_match, doc),
        link,
        Nokogiri::XML::Text.new(match.post_match, doc)
      ]
    end
  end
end
