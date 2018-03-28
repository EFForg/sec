ActiveAdmin.register_page "Surveys" do
  menu(false)

  controller do
    def index
      quick_questions = SurveyQuestion.order(:position).
                        where(survey: Feedback::QUICK_SURVEY)

      long_questions = SurveyQuestion.order(:position).
                        where(survey: Feedback::LONG_SURVEY)

      @surveys = {
        "Quick Feedback" => quick_questions,
        "Website Satisfaction" => long_questions
      }

      render layout: "active_admin"
    end
  end

  content do
    render template: "admin/surveys/index"
  end
end
