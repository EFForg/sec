ActiveAdmin.register Topic do
  permit_params :name, lessons_attributes: [:id, :name, :duration, :body, :topic_id]

  form do |f|
    f.inputs :name
    f.inputs do
      f.has_many :lessons, heading: 'Lessons',
                           allow_destroy: true do |a|
        a.input :name
        a.input :body
      end
    end
    f.actions
  end
end
