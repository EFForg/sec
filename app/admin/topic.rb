ActiveAdmin.register Topic do
  permit_params :name, lessons_attributes: [:id, :name, :duration_hours, :duration_minutes, :body, :topic_id, :_destroy]

  form do |f|
    f.inputs do
      f.input :name
      tabs do
        topic.lessons.each do |lesson|
          tab lesson.name do
            f.fields_for :lessons, lesson do |l|
              l.input :duration_hours, as: :number, label: 'Hours'
              l.input :duration_minutes, as: :number, label: 'Minutes'
              l.input :body, as: :ckeditor
              l.input :_destroy, as: :boolean, label: 'Delete this level'
            end
          end
        end
        tab '+Add' do
          f.fields_for :lessons, topic.lessons.new do |l|
            l.input :name
            l.input :duration_hours, as: :number, label: 'Hours'
            l.input :duration_minutes, as: :number, label: 'Minutes'
            l.input :body, as: :ckeditor
          end
        end
      end
    end
    f.actions
  end
end
