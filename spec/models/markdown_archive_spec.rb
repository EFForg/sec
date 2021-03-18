require 'rails_helper'

RSpec.describe MarkdownArchive do
  let(:topic){ FactoryGirl.create(:topic) }
  let(:article){ FactoryGirl.create(:article) }

  describe "#zip" do
    let(:markdown_archive){ MarkdownArchive.new(articles: [article], topics: [topic]) }

    it "should create a temp file" do
      expect(markdown_archive.zip).to start_with("/tmp/archive")
    end

    it "should contain paths to the topics and articles it is given" do
      tmpfile = markdown_archive.zip
      unzippedfiles = `unzip -l #{tmpfile}`

      expect(unzippedfiles).to include("Topics/A topic - Intro.md")
      expect(unzippedfiles).to include("Articles/An article.md")
    end

    it "should not delete the temp file" do
      expect(File.file?(markdown_archive.zip)).to eq true
    end
  end
end
