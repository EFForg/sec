class CreateSurveyResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_responses do |t|
      t.integer :feedback_id, null: false
      t.integer :survey_question_id, null: false
      t.text :value

      t.timestamps
    end
  end
end
