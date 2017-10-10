class AddDefaultToFeaturedContentPosition < ActiveRecord::Migration[5.1]
  def change
    change_table :featured_content do |t|
      t.change_default :position, 0
    end
  end
end
