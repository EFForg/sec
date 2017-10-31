require 'rails_helper'

RSpec.describe Material do
  describe "#name_after_attachment" do
    it "should set #name= to the attachment filename" do
      material = Material.new
      attachment = double(:"present?" => true, path: "/x/y/z.png")

      expect(material).to receive(:attachment){ attachment }.
                           at_least(:once)
      material.name_after_attachment

      expect(material.name).to eq("z.png")
    end

    it "should be a callback before save" do
      material = Material.new
      attachment = double(:"present?" => true, path: "/x/y/z.png")

      expect(material).to receive(:name_after_attachment)
      material.save
    end
  end
end
