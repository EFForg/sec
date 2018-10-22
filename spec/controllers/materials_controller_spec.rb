require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  let(:lesson){ FactoryGirl.create(:lesson) }
  let(:material){ FactoryGirl.create(:material) }

  describe "GET #index" do
    before do
      FactoryGirl.create(:page, name: "materials-overview")
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    describe "response" do
      render_views
      it "should include non-third party materials" do
        FactoryGirl.create(:material, name: "EFF teaching material")
        FactoryGirl.create(:material, name: "Third party material",
                                      third_party: true)

        get :index

        expect(response.body).to include("EFF teaching material")
        expect(response.body).not_to include("Third party material")
      end
    end
  end

  describe "GET #show" do
    it "returns http success" do
      lesson.update(
        suggested_materials: "/materials/#{material.to_param}"
      )

      get :show, params: { id: material.to_param }
      expect(response).to have_http_status(:success)
    end

    it "should protect unpublished content" do
      material.unpublish
      expect{ get :show, params: { id: material.slug } }.
        to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
