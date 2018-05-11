require 'rails_helper'

RSpec.feature "ShareLessonPlan", type: :feature do
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }

  before do
    page.set_rack_session(lesson_plan_id: lesson_plan.id)
  end

  let(:second_lesson) {
    second_lesson = FactoryGirl.create(:lesson)
    second_lesson.topic.update_attribute(:name,  "Another Topic")
    lesson_plan.lessons << second_lesson
    second_lesson
  }

  scenario "user shares a lesson plan", js: true do
    visit "/lesson-plan"
    click_link "Share"
    share_link = find(".copy-share-link input").value

    # Add another lesson to the lesson plan - it shouldn't appear in the shared version.
    second_lesson

    visit URI.parse(share_link).path
    expect(page).to have_content("A Topic")
    expect(page).to have_no_content("Another Topic")
  end
end
