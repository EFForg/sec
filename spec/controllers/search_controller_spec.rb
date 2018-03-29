require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #results" do
    before do
      FactoryGirl.create(:article,
                         name: "a searchable name",
                         body: "some searchable content")
    end

    it "returns http success" do
      get :results, params: { q: "searchable" }
      expect(response).to have_http_status(:success)
    end
  end

end
