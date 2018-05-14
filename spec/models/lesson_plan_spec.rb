require 'rails_helper'

RSpec.describe LessonPlan do
  describe "LessonPlan#find_or_create_by_key" do
    let(:lesson_plan_link) { FactoryGirl.create(:lesson_plan_link) }
    subject { LessonPlan.find_or_create_by_key(lesson_plan_link.key) }

    it "returns a lesson plan with lessons" do
      expect(subject.lessons.count).to eq(2)
    end

    it "returns a readonly lesson plan" do
      expect{subject.update_attribute(:lessons, [])}.
        to raise_error(ActiveRecord::ActiveRecordError)
    end

    describe "with an existing lesson plan" do
      let(:lesson_plan_link) { FactoryGirl.create(:used_lesson_plan_link) }

      it "returns a lesson plan with lessons" do
        expect(subject.lessons.count).to eq(2)
      end

      it "uses an existing lesson plan if one exists" do
        subject
        expect(LessonPlan.count).to eq(1)
      end
    end
  end
end
