class RemoveManagedContent < ActiveRecord::Migration[5.1]
  def change
    drop_table :managed_content
  end
end
