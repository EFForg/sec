ActiveAdmin.register Topic do
  permit_params :name, lessons_attributes: [:id, :name, :duration, :body, :topic_id]

  form do |f|
    f.inputs do
      f.input :name
      tabs do
        topic.lessons.each do |lesson|
          tab lesson.name do
            f.fields_for :lessons, lesson do |l|
              l.input :name
              l.input :duration
              l.input :body, as: :ckeditor
            end
          end
        end
        tab '+Add' do
          f.fields_for :lessons, topic.lessons.new do |l|
            l.input :name
            l.input :duration
            l.input :body, as: :ckeditor
          end
        end
      end
    end
    f.actions
  end
end
