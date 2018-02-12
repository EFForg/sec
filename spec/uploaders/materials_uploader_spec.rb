require 'rails_helper'

RSpec.describe MaterialsUploader do
  let(:uploader){ MaterialsUploader.new(Material.new) }

  describe "#full_preview" do
    it "should be the original file for images" do
      original = file_fixture("image.gif")
      uploader.store!(File.open(original))
      expect(uploader.full_preview).to be_present

      preview = uploader.full_preview.path
      expect(FileUtils.compare_file(original, preview)).to be true
    end

    pending "it should be the resized first page for PDFs"
  end

  describe "#thumbnail" do
    it "should be 210x210" do
      uploader.store!(File.open(file_fixture("image.gif")))
      expect(uploader.thumbnail).to be_present

      thumbnail = MiniMagick::Image.open(uploader.thumbnail.path)
      expect(thumbnail.dimensions).to eq([210, 210])
    end

    pending "should be converted to PNG for PDFs"
  end
end

