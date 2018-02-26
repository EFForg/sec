class SurveyQuestion < ApplicationRecord
  has_many :options, class_name: "SurveyOption", dependent: :destroy
  accepts_nested_attributes_for :options

  has_many :responses, class_name: "SurveyResponse"
end
