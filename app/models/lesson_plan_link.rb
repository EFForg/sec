class LessonPlanLink < ApplicationRecord
  validates_uniqueness_of :key, :lesson_ids
  before_validation :set_key, on: :create
  belongs_to :lesson_plan, optional: true

  private

  def set_key
    self.key = EffDiceware.generate(4).gsub(" ", "-")
  end
end
