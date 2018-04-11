require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  let(:lesson){ FactoryGirl.create(:lesson) }
  let(:material){ FactoryGirl.create(:material) }

  describe "GET #index" do
    it "returns http success" do
      FactoryGirl.create(:page, name: "materials-overview")
      get :index
      expect(response).to have_http_status(:success)
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
