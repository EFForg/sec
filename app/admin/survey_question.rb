ActiveAdmin.register SurveyQuestion do
  menu(false)

  config.sort_order = "position_desc"

  permit_params :prompt, :required, :survey,
                options_attributes: [:id, :position, :value]

  filter :survey

  index do
    id_column

    column :prompt
    column :required

    actions do |resource|
      link_to "Show Responses", show_responses_admin_survey_question_path(resource)
    end
  end

  form do |f|
    f.inputs do
      f.input :prompt

      f.has_many :options, heading: "Options (leave empty for textfield)", sortable: :position, allow_destroy: true do |o|
        o.input :value
      end

      f.input :required
    end

    if survey_question.new_record?
      survey_question.survey = Feedback::LONG_SURVEY
    end

    f.input :survey, as: :hidden

    f.actions
  end

  member_action :show_responses do
    @survey_question = resource
    render layout: "active_admin"
  end

  controller do
    def update
      update! do
        admin_survey_questions_path("q[survey_equals]" => resource.survey)
      end
    end

    def create
      create! do
        admin_survey_questions_path("q[survey_equals]" => resource.survey)
      end
    end
  end
end
