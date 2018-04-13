require 'rails_helper'

RSpec.describe Lesson do
  def wysiwyg_for_materials(materials)
    materials.map do |m|
      url = Rails.application.routes.url_helpers.material_path(m)
      "<p>#{m.name}</p><a href='#{url}'>link</a>"
    end.join
  end

  describe "#materials" do
    it "returns an empty array" do
      expect(FactoryGirl.create(:lesson).materials).to be_empty
    end

    context "with materials" do
      let!(:material) { FactoryGirl.create(:material, name: "A rad handout") }
      let!(:material2) { FactoryGirl.create(:material, name: "A Great GIF") }
      let!(:not_my_material) { FactoryGirl.create(:material) }
      let(:lesson) do
        FactoryGirl.create(
          :lesson, suggested_materials: wysiwyg_for_materials([material, material2])
        )
      end

      it "returns linked materials" do
        expect(lesson.materials).to match_array([material, material2])
      end
    end
  end
end
