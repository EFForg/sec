class Material < ApplicationRecord
  mount_uploader :attachment, MaterialsAttachmentUploader
end
