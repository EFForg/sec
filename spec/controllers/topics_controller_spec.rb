require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  let(:topic){ FactoryGirl.create(:topic) }

  describe "GET #index" do
    it "returns http success" do
      FactoryGirl.create(:page, name: "topics-overview")
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
      topic.unpublish
      expect{ get :show, params: { id: topic.slug } }.
        to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
