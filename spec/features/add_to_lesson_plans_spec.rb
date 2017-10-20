require 'rails_helper'

RSpec.feature "AddToLessonPlans", type: :feature do
  let(:topic){ FactoryGirl.create(:topic) }
  let(:lesson){ topic.lessons.first }

  scenario "user adds a lesson to a new lesson plan" do
    visit topic_path(topic)

    click_button "Add To Lesson Plan (0)"

    expect(LessonPlan.count).to eq(1)
    expect(LessonPlan.take.lesson_ids).to eq([lesson.id])
    find_button("Add To Lesson Plan (1)")
  end
end
