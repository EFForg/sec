class LessonPlan < ApplicationRecord
  has_many :lesson_plan_lessons
  has_many :lessons, through: :lesson_plan_lessons

  accepts_nested_attributes_for :lesson_plan_lessons, allow_destroy: true

  validates_uniqueness_of :key
  before_validation :set_key, on: :create

  def to_param
    key
  end

  private

  def set_key
    self.key = SecureRandom.uuid
  end
end
