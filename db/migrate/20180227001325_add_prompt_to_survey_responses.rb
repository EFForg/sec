class AddPromptToSurveyResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_responses, :prompt, :string, null: false, default: ""

    reversible do |dir|
      dir.up do
        SurveyResponse.all.find_each do |response|
          response.prompt = response.survey_question.prompt
          response.save
        end
      end
    end
  end
end
