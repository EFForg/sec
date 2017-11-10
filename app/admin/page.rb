ActiveAdmin.register Page do
  actions :all, :except => [:new, :destroy]
  permit_params :body

  config.filters = false

  index do
    selectable_column
    column :name do |n|
      n.name.titleize
    end
    actions
  end

  form do |f|
    if f.object.name == "homepage"
      f.template.render partial: 'pages/homepage'
    end
    f.semantic_errors *f.object.errors.keys
    f.input :body, label: f.object.body_alias
    f.actions
  end
end

