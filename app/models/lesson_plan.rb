class LessonPlan < ApplicationRecord
  has_many :lesson_plan_lessons
  has_many :lessons, through: :lesson_plan_lessons

  accepts_nested_attributes_for :lesson_plan_lessons, allow_destroy: true

  validates_uniqueness_of :key
  before_create :create_key

  def to_param
    key
  end

  private

  def create_key
    self.key = SecureRandom.uuid
  end
end
