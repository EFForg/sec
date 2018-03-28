ActiveAdmin.register Feedback do
  menu(false)

  actions :all, except: [:edit]

  filter :created_at

  member_action :show do
    @feedback = resource
    render layout: "active_admin"
  end
end
