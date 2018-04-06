require 'rails_helper'

RSpec.feature "AddToLessonPlans", type: :feature, js: true do
  let(:topic){ FactoryGirl.create(:topic) }
  let(:lesson){ topic.lessons.first }
  let(:lesson_plan) { FactoryGirl.create(:lesson_plan) }

  context "lesson plan doesn't exist yet" do
    scenario "user adds a lesson to a new lesson plan" do
      visit topic_path(topic)

      button = click_button("Add To Lesson Plan")
      expect(button.text).to include("(0)")

      button = find_button("Remove From Lesson Plan")
      expect(button.text).to include("(1)")

      expect(LessonPlan.count).to eq(1)
      expect(LessonPlan.take.lesson_ids).to eq([lesson.id])
    end
  end

  context "lesson plan exists" do
    before{ page.set_rack_session(lesson_plan_id: lesson_plan.id) }
    scenario "user adds a lesson to an existing lesson plan" do
      lesson_plan.lessons << FactoryGirl.create(:topic).lessons.first

      visit topic_path(topic)
      click_button "Add To Lesson Plan"
      find_button("Remove From Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(2)
    end

    scenario "user removes a lesson from a lesson plan" do
      lesson_plan.lessons << lesson

      visit topic_path(topic)
      click_button "Remove From Lesson Plan"
      find_button("Add To Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(0)
    end
  end
end
