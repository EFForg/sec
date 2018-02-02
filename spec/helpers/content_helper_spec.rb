require 'rails_helper'

RSpec.describe ContentHelper do
  let(:article) { Article.new }

  describe '#preview' do
    it 'should strip content of pull quotes' do
      article.body = %(<p>a</p><p class="pull-quote">b</p><p>c</p>)

      expect(helper.strip_tags(helper.preview(article))).to eq("ac")
    end
  end
end
