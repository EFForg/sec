class AddUpdateNotesToHomepages < ActiveRecord::Migration[5.1]
  def change
    add_column :homepages, :update_notes, :text
  end
end
