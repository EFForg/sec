class Upload < ApplicationRecord
  mount_uploader :file, MaterialsUploader
  belongs_to :material
end
