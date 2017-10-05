ActiveAdmin.register Topic do
  permit_params :name,
    lessons_attributes: [
        :id, :_destroy, :level_id, :topic_id,
        :duration_hours, :duration_minutes, :instructors, :students,
        :objective, :body,
        lesson_prereqs_attributes: [
          :id, :_destroy, :content_type, :content_id, :position
        ]
      ]

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :name
      tabs do
        topic.lessons.each do |lesson|
          if lesson.persisted?
            tab lesson.level do
              render partial: 'admin/lessons/fields', locals: { f: f, lesson: lesson }
            end
          end
        end
        if topic.lessons.unused_levels.any?
          tab '+Add' do
            render partial: 'admin/lessons/fields',
              locals: { f: f, topic: topic, lesson: topic.unsaved_or_new_lesson }
          end
        end
      end
    end
    f.actions
  end
end
