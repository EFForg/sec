class LessonResource < ApplicationRecord
  belongs_to :resource, polymorphic: true, touch: true
end
