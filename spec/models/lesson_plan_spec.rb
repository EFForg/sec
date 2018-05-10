require 'rails_helper'

RSpec.describe LessonPlan do
  describe "LessonPlan#from_share_string" do
    let(:lesson_plan_link) { FactoryGirl.create(:lesson_plan_link) }
    subject { LessonPlan.from_share_string(lesson_plan_link.key) }

    it "returns a lesson plan with lessons" do
      expect(subject.lessons.count).to eq(2)
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
