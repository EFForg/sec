class Icon < ApplicationRecord
  mount_uploader :file, IconUploader

  delegate :url, to: :file
end
