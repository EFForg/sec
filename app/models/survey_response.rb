class SurveyResponse < ApplicationRecord
  belongs_to :feedback
  belongs_to :survey_question

  validates_presence_of :value, if: ->{ survey_question.required? }
end
