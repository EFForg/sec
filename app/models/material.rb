class Material < ApplicationRecord
  mount_uploader :attachment, MaterialsAttachmentUploader

  before_validation :name_after_attachment, if: ->(m){ m.name.blank? }

  def name_after_attachment
    if attachment.present?
      self.name = File.basename(attachment.path)
    end
  end
end
