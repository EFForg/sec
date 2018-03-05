require 'rails_helper'

RSpec.describe GlossaryHelper do
  def sanitize(doc)
    doc.tap{ doc.css('img').each(&:remove) }
  end

  describe '#link_glossary_terms' do
    let(:html){ '<p>glossary helper spec</p>' }
    let(:html_with_repeated_term){ '<p>glossary helper spec with glossary term</p>' }
    let(:doc) { Nokogiri::HTML.fragment(html) }

    it 'should do nothing when the document contains no terms' do
      helper.link_glossary_terms(doc)
      expect(sanitize(doc).to_html).to eq(html)
    end

    it 'should replace glossary terms in the document with links' do
      GlossaryTerm.create!(name: 'glossary')
      GlossaryTerm.create!(name: 'Spec')

      helper.link_glossary_terms(doc)

      links = sanitize(doc).css('a')
      expect(links.map { |el| el[:href] }).to match_array(
        GlossaryTerm.all.map { |term| "/glossary/#{term.name.downcase}" }
      )
      expect(links.map { |el| el[:class] }.uniq).to eq(["glossary-term"])
    end

    it 'should not replace content in inappropriate contexts' do
      html.gsub!('<p>', '<pre>').gsub!('</p>', '</pre>')
      html << '<p>the <a>glossary</a> helper spec</p>'

      GlossaryTerm.create!(name: 'glossary')

      helper.link_glossary_terms(doc)
      expect(sanitize(doc).to_html).to eq(html)
    end

    it 'should not link a term more than once' do
      doc = Nokogiri::HTML.fragment(html_with_repeated_term)

      GlossaryTerm.create!(name: 'glossary')

      helper.link_glossary_terms(doc)
      expect(sanitize(doc).css('a.glossary-term').size).to eq(1)

      doc = Nokogiri::HTML.fragment(html_with_repeated_term)
      helper.link_glossary_terms(doc)
      expect(sanitize(doc).css('a.glossary-term')).to be_empty
    end

    it 'should link synonyms' do
      term = GlossaryTerm.create!(name: "dictionary", synonyms: ["glossary"])

      helper.link_glossary_terms(doc)
      links = sanitize(doc).css('a')

      expect(links.select do |el|
        el.content.include?(term.synonyms.first) &&
          el[:href] == "/glossary/#{term.name}"
      end).to be_present
    end

    it 'should link to the most precisely matching term' do
      GlossaryTerm.create!(name: "glossary")
      best_match = GlossaryTerm.create!(name: "glossary helper")

      helper.link_glossary_terms(doc)
      links = sanitize(doc).css('a')

      expect(links.map { |el| el[:href] }).to eq(
        ["/glossary/#{best_match.name.parameterize}"]
      )
    end
  end
end
