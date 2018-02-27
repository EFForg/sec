class CreateQuickSurvey < ActiveRecord::Migration[5.1]
  def up
    q = SurveyQuestion.create(
      survey: "quick",
      prompt: "Did you find what you were looking for?"
    )

    q.options << SurveyOption.new(value: "Yes")
    q.options << SurveyOption.new(value: "Partially")
    q.options << SurveyOption.new(value: "No")

    SurveyQuestion.create(
      survey: "quick",
      prompt: "Share what you like best or what could we do to improve Security Education"
    )
  end

  def down
    SurveyQuestion.where(survey: "quick").destroy_all
  end
end
