require 'rails_helper'

RSpec.describe BlogController, type: :controller do
  let(:blog_post){ FactoryGirl.create(:blog_post) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: blog_post.slug }
      expect(response).to have_http_status(:success)
    end
  end

end
