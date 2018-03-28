class AddUpdateNotesUpdatedAtToHomepages < ActiveRecord::Migration[5.1]
  def change
    add_column :homepages, :update_notes_updated_at, :datetime
  end
end
