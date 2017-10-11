ActiveAdmin.register Topic do
  permit_params :name, :slug,
    lessons_attributes: [
        :id, :_destroy, :level_id, :topic_id,
        :instructors, :students,
        :objective, :body,
        tag_ids: [],
        duration: [:hours, :minutes],
        lesson_prereqs_attributes: [
          :id, :_destroy, :resource_type, :resource_id, :position
        ],
        lesson_materials_attributes: [
          :id, :_destroy, :resource_type, :resource_id, :position
        ],
        lesson_articles_attributes: [
          :id, :_destroy, :resource_type, :resource_id, :position
        ],
      ]


  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :name
      tabs do
        topic.lessons.each do |lesson|
          if lesson.persisted?
            tab lesson.level do
              render partial: "admin/lessons/fields", locals: { f: f, lesson: lesson }
            end
          end
        end
        if topic.lessons.unused_levels.any?
          tab "+Add" do
            render partial: "admin/lessons/fields",
              locals: { f: f, topic: topic, lesson: topic.unsaved_or_new_lesson }
          end
        end
      end
    end
    f.actions
  end

  sidebar :topic_extras, only: :edit do
    render partial: "admin/topics/extra",
      locals: { topic: resource }
  end
end
