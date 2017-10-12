require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  let(:topic){ FactoryGirl.create(:topic) }

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { topic_id: topic.slug,
                           id: topic.lessons.first.level }
      expect(response).to have_http_status(:success)
    end
  end

end
