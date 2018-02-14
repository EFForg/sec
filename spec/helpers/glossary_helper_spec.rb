require 'rails_helper'

RSpec.describe GlossaryHelper do
  def sanitize(doc)
    doc.tap{ doc.css('img').each(&:remove) }
  end

  describe '#link_glossary_terms' do
    it 'should do nothing when the document contains no terms' do
      html = '<p>glossary helper spec</p>'
      doc = Nokogiri::HTML.fragment(html)

      helper.link_glossary_terms(doc)
      expect(sanitize(doc).to_html).to eq(html)
    end

    it 'should replace glossary terms in the document with links' do
      html = '<p>glossary helper spec</p>'
      doc = Nokogiri::HTML.fragment(html)

      GlossaryTerm.create!(name: 'glossary')
      GlossaryTerm.create!(name: 'Spec')

      helper.link_glossary_terms(doc)

      expect(sanitize(doc).to_html).
        to eq('<p><a href="/glossary/glossary" class="glossary-term">glossary</a> helper <a href="/glossary/spec" class="glossary-term">spec</a></p>')
    end

    it 'should not replace content in inappropriate contexts' do
      html = '<pre>glossary helper spec</pre>' <<
             '<p>the <a>glossary</a> helper spec</p>'
      doc = Nokogiri::HTML.fragment(html)

      GlossaryTerm.create!(name: 'glossary')

      helper.link_glossary_terms(doc)
      expect(sanitize(doc).to_html).to eq(html)
    end

    it 'should not link a term more than once' do
      html = '<p>glossary helper spec with glossary term</p>'
      doc = Nokogiri::HTML.fragment(html)

      GlossaryTerm.create!(name: 'glossary')

      helper.link_glossary_terms(doc)
      expect(sanitize(doc).css('a.glossary-term').size).to eq(1)

      doc = Nokogiri::HTML.fragment(html)
      helper.link_glossary_terms(doc)
      expect(sanitize(doc).css('a.glossary-term')).to be_empty
    end

    it 'should link synonyms' do
      html = '<p>glossary helper spec</p>'
      doc = Nokogiri::HTML.fragment(html)

      GlossaryTerm.create!(name: "dictionary", synonyms: ["glossary"])

      helper.link_glossary_terms(doc)
      expect(sanitize(doc).to_html).
        to eq('<p><a href="/glossary/dictionary" class="glossary-term">glossary</a> helper spec</p>')
    end
  end
end
