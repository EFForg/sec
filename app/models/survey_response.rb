class SurveyResponse < ApplicationRecord
  belongs_to :feedback
  belongs_to :survey_question

  validates_presence_of :value, if: ->{ survey_question.required? }

  before_create :copy_prompt_from_question

  private

  def copy_prompt_from_question
    self.prompt = survey_question.prompt
  end
end
