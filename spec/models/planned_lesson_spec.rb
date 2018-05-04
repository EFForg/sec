require 'rails_helper'

RSpec.describe PlannedLesson do
  it "should be added to the end of the plan" do
    lesson_plan = FactoryGirl.create(:lesson_plan_with_lesson)
    new_lesson = FactoryGirl.create(:lesson)
    lesson_plan.lessons << new_lesson
    expect(PlannedLesson.find_by(lesson: new_lesson).position).
      to be > lesson_plan.planned_lessons.first.position
  end
end
