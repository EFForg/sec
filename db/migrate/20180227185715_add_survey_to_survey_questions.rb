class AddSurveyToSurveyQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_questions, :survey, :string, null: false, default: ""

    reversible do |dir|
      dir.up do
        SurveyQuestion.update_all(survey: "/feedback")
      end
    end
  end
end
