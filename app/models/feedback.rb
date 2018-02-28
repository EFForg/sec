class Feedback < ApplicationRecord
  has_many :survey_responses, dependent: :destroy
  accepts_nested_attributes_for :survey_responses

  QUICK_SURVEY = "quick".freeze
  LONG_SURVEY = "/feedback".freeze
end
