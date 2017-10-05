class Topic < ApplicationRecord
  has_many :lessons
  accepts_nested_attributes_for :lessons, allow_destroy: true, reject_if: :all_blank

  def unsaved_or_new_lesson
    lessons.find(&:new_record?) || lessons.new
  end
end
