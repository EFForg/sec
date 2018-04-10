require 'rails_helper'

RSpec.describe UpdateLessonPdf do
  let(:lesson){ FactoryGirl.create(:topic).lessons.take }

  describe "#perform" do
    it "should create a PDF" do
      pdf = double()
      expect_any_instance_of(PdfTemplate).to receive(:render){ pdf }

      expect(Lesson).to receive(:find){ lesson }
      expect(lesson).to receive(:update!).with(pdf: pdf)
      UpdateLessonPdf.new.perform(lesson.id)
    end
  end
end
