require 'rails_helper'

RSpec.feature "ManageLessonPlan", type: :feature do
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }

  let(:lots_of_lessons) {
    FactoryGirl.create_list(:lesson, 4, duration: Duration.new(1.hour))
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

  scenario "user dismisses notice about lesson plan length", js: true do
    lesson_plan.lessons << lots_of_lessons
    visit "/lesson-plan"

    expect(page).to have_content("This seems like a lot to cover for one day!")

    click_on "Ok"

    page.driver.refresh

    expect(page).not_to have_content("This seems like a lot to cover for one day!")
  end
end
