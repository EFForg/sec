require 'rails_helper'

RSpec.feature "ManageLessonPlan", type: :feature do
  let(:topic){ FactoryGirl.create(:topic) }
  let(:lesson){ topic.lessons.first }
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }

  scenario "user removes a lesson from their lesson plan" do
    page.set_rack_session(lesson_plan_id: lesson_plan.id)

    visit "/lesson-plan"
    click_button "Remove this lesson"

    expect(lesson_plan.lessons.count).to eq(0)
  end
end
