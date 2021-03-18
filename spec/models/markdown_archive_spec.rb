require 'rails_helper'

RSpec.describe MarkdownArchive do
  let(:markdown_archive){ MarkdownArchive.new }

  describe "#zip" do
    it "should create a temp file" do
      expect(markdown_archive.zip).to start_with("/tmp/archive")
    end

    it "should delete the temp file" do
      expect(File.file?(markdown_archive.zip)).to eq false
    end
  end
end
