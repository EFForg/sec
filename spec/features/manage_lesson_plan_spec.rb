require 'rails_helper'

RSpec.feature "ManageLessonPlan", type: :feature do
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }

  let(:second_lesson) {
    second_lesson = FactoryGirl.create(:lesson)
    second_lesson.topic.update_attribute(:name,  "Another Topic")
    lesson_plan.lessons << second_lesson
    second_lesson
  }

  before do
    page.set_rack_session(lesson_plan_id: lesson_plan.id)
  end

  [true, false].each do |has_js|
    scenario "user removes a lesson #{has_js ? "with" : "without"} js", js: has_js do
      visit "/lesson-plan"
      click_button "Remove this lesson"

      expect(page).to have_no_content("A topic")
      expect(lesson_plan.lessons.count).to eq(0)
    end
  end

  scenario "user reorders lessons", js: true do
    second_lesson
    visit "/lesson-plan"

    lesson = find(".lesson:nth-child(2) .handle")
    target = find(".lesson:nth-child(1)")
    lesson.drag_to target

    expect(find(".lesson:nth-child(1)")).to have_content("Another Topic")
    expect(lesson_plan.lesson_plan_lessons.find_by(lesson: second_lesson).position).to eq(0)
  end
end
