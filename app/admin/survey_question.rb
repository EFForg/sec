ActiveAdmin.register SurveyQuestion do
  menu priority: 6

  config.sort_order = "position_desc"

  permit_params :prompt, :required,
                options_attributes: [:id, :position, :value]

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
end
