class Page < ApplicationRecord
  include FriendlyLocating
  has_many :managed_content
end

