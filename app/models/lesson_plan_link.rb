class LessonPlanLink < ApplicationRecord
  validates_uniqueness_of :key
  before_validation :set_key, on: :create

  private

  def set_key
    self.key = EffDiceware.generate(4).gsub(" ", "-")
  end
end
