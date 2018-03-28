class CreateFeedback < ActiveRecord::Migration[5.1]
  def change
    create_table :feedback do |t|
      t.timestamps
    end
  end
end
