require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:article){ FactoryGirl.create(:article) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: article.slug }
      expect(response).to have_http_status(:success)
    end
  end

end
