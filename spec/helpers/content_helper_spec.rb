require 'rails_helper'

RSpec.describe ContentHelper do
  let(:article) { Article.new(body: '<p></p>') }

  describe '#preview' do
    it 'should strip content of pull quotes' do
      article.body = %(<p>a</p><p class="pull-quote">b</p><p>c</p>)

      expect(helper.strip_tags(helper.preview(article))).to eq("ac")
    end
  end

  describe '#html' do
    it 'should call #link_glossary_terms if glossary option is given' do
      expect(helper).to receive(:link_glossary_terms)
      helper.html(article.body, glossary: true)

      expect(helper).not_to receive(:link_glossary_terms)
      helper.html(article.body)
    end
  end
end
