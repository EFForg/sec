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

    it 'should create popover definitions for glossary terms' do
      GlossaryTerm.create!(name: 'glossary', body: 'definition')
      GlossaryTerm.create!(name: 'Spec', body: 'another')

      helper.link_glossary_terms(doc)

      expect(sanitize(doc).css('.glossary-term').count).to eq(GlossaryTerm.count)
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
      expect(sanitize(doc).css('.glossary-term').size).to eq(1)

      doc = Nokogiri::HTML.fragment(html_with_repeated_term)
      helper.link_glossary_terms(doc)
      expect(sanitize(doc).css('.glossary-term')).to be_empty
    end


    it 'should include definition from the most precisely matching term' do
      GlossaryTerm.create!(name: "glossary", body: "just ok")
      best_match = GlossaryTerm.create!(name: "glossary helper", body: "better")

      helper.link_glossary_terms(doc)

      expect(sanitize(doc).css('.glossary-term').map { |el| el["data-description"] }[0])
        .to include(best_match.body)
    end

    context 'when definition is too long' do
      let!(:term) { GlossaryTerm.create!(name: "glossary", body: 'cats' * 200) }

      it 'links to the glossary when definition is too long' do
        helper.link_glossary_terms(doc)

        links = sanitize(doc).css('a')
        expect(links.map { |el| el[:href] }).to eq(["/glossary/#{term.slug}"])
      end

      it 'should link synonyms' do
        term.update(synonyms: ["glossary"])

        helper.link_glossary_terms(doc)
        el = sanitize(doc).css('.glossary-term').first

        expect(el.content.split("\n").first).to eq(term.synonyms.first)
        expect(el[:href]).to eq("/glossary/#{term.name}")
      end
    end
  end
end
