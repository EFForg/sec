require 'rails_helper'

RSpec.feature "ManageLessonPlan", type: :feature, js: true do
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }

  let(:second_lesson) {
    second_lesson = FactoryGirl.create(:lesson)
    second_lesson.topic.update_attribute(:name,  "Another Topic")
    lesson_plan.lessons << second_lesson
    second_lesson
  }

  let(:lots_of_lessons) {
    FactoryGirl.create_list(:lesson, 4, duration: Duration.new(1.hour))
  }

  before do
    page.set_rack_session(lesson_plan_id: lesson_plan.id)
  end

  scenario "user removes a lesson from their lesson plan" do
    visit "/lesson-plan"
    click_button "Remove this lesson"

    expect(page).to have_no_content("A topic")
    expect(lesson_plan.lessons.count).to eq(0)
  end

  scenario "user reorders lessons" do
    second_lesson
    visit "/lesson-plan"

    lesson = find(".lesson:nth-child(2) .handle")
    target = find(".lesson:nth-child(1)")
    lesson.drag_to target

    expect(find(".lesson:nth-child(1)")).to have_content("Another Topic")
    expect(lesson_plan.lesson_plan_lessons.find_by(lesson: second_lesson).position).to eq(0)
  end

  scenario "user dismisses notice about lesson plan length" do
    lesson_plan.lessons << lots_of_lessons
    visit "/lesson-plan"

    expect(page).to have_css("body.is-reveal-open")
    expect(page).to have_content("This seems like a lot to cover for one day!")

    click_on "Ok"

    page.driver.refresh

    expect(page).not_to have_content("This seems like a lot to cover for one day!")
  end
end
