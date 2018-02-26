ActiveAdmin.register SurveyQuestion do
  menu priority: 6

  config.sort_order = "position_desc"

  permit_params :prompt, :required,
                options_attributes: [:id, :position, :value]

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

      f.has_many :options, label: "xyz", sortable: :position, allow_destroy: true do |o|
        o.input :value
      end

      f.input :required
    end

    f.actions
  end

  member_action :show_responses do
    @survey_question = resource
    render layout: "active_admin"
  end
end
