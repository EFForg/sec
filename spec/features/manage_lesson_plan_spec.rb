require 'rails_helper'

RSpec.feature "ManageLessonPlan", type: :feature do
  let(:topic){ FactoryGirl.create(:topic) }
  let(:lesson){ topic.lessons.first }
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }

  scenario "user removes a lesson from their lesson plan" do
    allow_any_instance_of(LessonPlansHelper).to receive(:current_lesson_plan) do
      LessonPlan.find(lesson_plan.id)
    end

    visit "/lesson-plan"
    click_button "Remove this lesson"

    expect(lesson_plan.lessons.count).to eq(0)
  end
end
