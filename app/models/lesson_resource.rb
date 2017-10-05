class LessonResource < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
