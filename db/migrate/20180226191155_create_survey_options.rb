class CreateSurveyOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_options do |t|
      t.integer :survey_question_id, null: false
      t.integer :position, null: false, default: 0
      t.string :value, null: false

      t.timestamps
    end
  end
end
