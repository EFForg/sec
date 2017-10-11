ActiveAdmin.register Topic do
  permit_params :name, :slug,
    lessons_attributes: [
        :id, :_destroy, :level_id, :topic_id,
        :duration_hours, :duration_minutes, :instructors, :students,
        :objective, :body,
        tag_ids: [],
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

    before_action :blankify_empty_tags_list, only: [:create, :update]

    def blankify_empty_tags_list
      params[:topic][:lessons_attributes].each do |key, attributes|
        params[:topic][:lessons_attributes][key][:tag_ids].reject!(&:blank?)
      end
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :name
      tabs do
        topic.lessons.tap(&:build_unused_level).each do |lesson|
          tab(lesson.level || "+Add") do
            render partial: "admin/lessons/fields",
              locals: { f: f, lesson: lesson }
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
