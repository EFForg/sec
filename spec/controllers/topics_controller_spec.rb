require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  let(:topic){ FactoryGirl.create(:topic) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: topic.slug }
      expect(response).to have_http_status(:success)
    end

    it "should protect unpublished content" do
      expect(controller).to receive(:protect_unpublished!)
      get :show, params: { id: topic.slug }
    end
  end

end
