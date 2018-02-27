class Feedback < ApplicationRecord
  has_many :survey_responses, dependent: :destroy
  accepts_nested_attributes_for :survey_responses
end
