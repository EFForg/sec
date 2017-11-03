require 'rails_helper'

RSpec.describe Upload do
  describe "#name_after_file" do
    it "should set #name= to the file filename" do
      upload = Upload.new
      file = double(:"present?" => true, path: "/x/y/z.png")

      expect(upload).to receive(:file){ file }.
                           at_least(:once)
      upload.name_after_file

      expect(upload.name).to eq("z.png")
    end

    it "should be a callback before save" do
      upload = Upload.new
      file = double(:"present?" => true, path: "/x/y/z.png")

      expect(upload).to receive(:name_after_file)
      upload.save
    end
  end
end
