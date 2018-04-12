require 'rails_helper'

RSpec.describe UpdateLessonPdf do
  let(:lesson){ FactoryGirl.create(:lesson) }

  describe "#perform" do
    it "should create a PDF" do
      expect(lesson.reload.pdf).not_to be_present

      UpdateLessonPdf.new.perform(lesson.id)

      expect(lesson.reload.pdf).to be_present
    end
  end
end
