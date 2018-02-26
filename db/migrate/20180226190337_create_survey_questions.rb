class CreateSurveyQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_questions do |t|
      t.integer :position, null: false, default: 0
      t.string :prompt, null: false
      t.boolean :required, null: false, default: false

      t.timestamps
    end
  end
end
