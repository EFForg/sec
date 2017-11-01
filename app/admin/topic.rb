ActiveAdmin.register Topic do
  include ViewingInApp

  menu parent: "Content", priority: 1

  permit_params :name, :description, :icon, :slug, :published,
    tag_ids: [],
    lessons_attributes: [
        :id, :_destroy, :level_id, :topic_id,
        :instructor_students_ratio,
        :objective, :body,
        duration: [:hours, :minutes],
        prereq_ids: [],
        material_ids: [],
        advice_ids: [],
      ]

  filter :name
  filter :tags
  filter :created_at
  filter :updated_at
  filter :slug

  index do
    selectable_column
    column :name
    column :published_at
    actions do |resource|
      link_to "View", resource
    end
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :name
      f.input :description
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
