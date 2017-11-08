class ManagedContent < ApplicationRecord
  self.table_name = :managed_content
  belongs_to :page
end
