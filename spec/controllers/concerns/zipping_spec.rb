require 'rails_helper'

RSpec.describe Zipping do
  controller_class = Class.new(ApplicationController) do
    include Zipping
  end

  let(:controller) do
    controller_class.new.tap do |c|
      c.response = ActionDispatch::Response.new
    end
  end

  let(:files) do
    5.times.map do |i|
      double(
        size: rand(10000),
        path: Rails.root.join("public", "files/file #{i}.pdf").to_s
      )
    end
  end

  describe "#send_archive(files)" do
    it "should set the X-Archive-Files header" do
      expect(controller.response.headers)
        .to receive(:[]=).with("X-Archive-Files", "zip").once

      allow(controller.response.headers)
        .to receive(:[]=).and_call_original

      controller.send_archive(files)
    end

    it "should send a response formatted for nginx's zip module" do
      expect(controller).to receive(:send_data) do |*args|
        manifest, opts = args

        ref = files.map do |f|
          path = URI::escape(f.path[Rails.root.join("public").to_s.size..-1])
          name = File.basename(f.path)
          "- #{f.size} #{path} #{name}"
        end.join("\r\n")

        expect(manifest).to eq(ref)
      end

      controller.send_archive(files, number: false)
    end
  end
end
