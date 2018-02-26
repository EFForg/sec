class SurveyResponse < ApplicationRecord
  belongs_to :feedback
  belongs_to :survey_question
end
