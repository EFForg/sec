require 'rails_helper'

RSpec.feature "AddToLessonPlans", type: :feature do
  let(:topic){ FactoryGirl.create(:topic) }
  let(:lesson){ topic.lessons.first }
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan) }

  scenario "user adds a lesson to a new lesson plan" do
    visit topic_path(topic)

    button = click_button "Add To Lesson Plan"
    expect(button.text).to include("(0)")

    expect(LessonPlan.count).to eq(1)
    expect(LessonPlan.take.lesson_ids).to eq([lesson.id])

    button = find_button("Remove From Lesson Plan")
    expect(button.text).to include("(1)")
  end

  scenario "user adds a lesson to an existing lesson plan" do
    lesson_plan.lessons << FactoryGirl.create(:topic).lessons.first
    allow_any_instance_of(LessonPlansHelper).to receive(:current_lesson_plan) do
      LessonPlan.find(lesson_plan.id)
    end
    visit topic_path(topic)
    click_button "Add To Lesson Plan"
    expect(lesson_plan.lessons.count).to eq(2)
  end

  scenario "user removes a lesson from a lesson plan" do
    lesson_plan.lessons << lesson
    allow_any_instance_of(LessonPlansHelper).to receive(:current_lesson_plan) do
      LessonPlan.find(lesson_plan.id)
    end
    visit topic_path(topic)
    click_button "Remove From Lesson Plan"
    expect(lesson_plan.lessons.count).to eq(0)
    find_button "Add To Lesson Plan"
  end
end
