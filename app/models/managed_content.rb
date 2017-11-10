class ManagedContent < ApplicationRecord
  self.table_name = :managed_content
  belongs_to :page, optional: true

  scope :region, -> (region) { find_by(region: region).frst.try(:body) }
end
