require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  let(:lesson){ FactoryGirl.create(:lesson) }

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { topic_id: lesson.topic.slug, id: lesson.level }
      expect(response).to have_http_status(:success)
    end

    it "should protect unpublished content" do
      lesson.topic.unpublish
      expect {
        get :show, params: { topic_id: lesson.topic.slug, id: lesson.level }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
