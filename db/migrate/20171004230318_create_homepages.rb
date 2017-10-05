class CreateHomepages < ActiveRecord::Migration[5.1]
  def change
    create_table :homepages do |t|
      t.text :welcome, null: false
      t.text :articles_intro, null: false

      t.timestamps
    end
  end
end
