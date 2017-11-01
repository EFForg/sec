require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  let(:topic){ FactoryGirl.create(:topic) }
  let(:material){ FactoryGirl.create(:material) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      topic.lessons.take.update(
        required_materials: "/materials/#{material.to_param}"
      )

      get :show, params: { id: material.to_param }
      expect(response).to have_http_status(:success)
    end
  end

end
