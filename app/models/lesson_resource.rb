class LessonResource < ApplicationRecord
  belongs_to :content, polymorphic: true
end
