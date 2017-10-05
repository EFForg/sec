class Material < ApplicationRecord
  has_attached_file :attachment,
    path: ":rails_root/public/files/materials/:id/:filename",
    url: "/files/materials/:id/:filename"

  do_not_validate_attachment_file_type :attachment
end
