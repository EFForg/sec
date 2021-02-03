require 'rails_helper'

RSpec.describe LessonPlansController, type: :controller do
  let(:lesson_plan){ FactoryGirl.create(:lesson_plan_with_lesson) }
  let(:files){ double(all?: true) }
  let(:topic){ FactoryGirl.create(:topic) }

  describe ".zip format" do
    it "should send back send_archive(lesson_plan.files)" do
      expect_any_instance_of(LessonPlan).to receive(:files){ files }
      expect(controller).to receive(:send_archive).with(files) do
        controller.head :ok
      end

      get :show, params: { id: lesson_plan.key!, format: :zip }
    end
  end

  describe "POST #create_lessons_by_topic" do
    it "returns http success" do
      get :show, params: { lesson_plan_id: lesson_plan.id, topic_id: topic.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy_lessons_by_topic" do
    it "returns http success" do
      get :show, params: { lesson_plan_id: lesson_plan.id, topic_id: topic.id }
      expect(response).to have_http_status(:success)
    end
  end
end
