class Feedback < ApplicationRecord
  has_many :survey_responses
  accepts_nested_attributes_for :survey_responses
end
