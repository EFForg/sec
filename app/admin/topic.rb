ActiveAdmin.register Topic do
  include ViewingInApp

  menu parent: "Content", priority: 2

  permit_params :name, :description, :icon_id, :slug, :published, :next_topic_id,
    tag_ids: [],
    admin_lessons_attributes: [
      :id, :level_id, :topic_id,
      :instructor_students_ratio,
      :objective, :notes, :body,
      :relevant_articles, :recommended_reading,
      :prerequisites, :suggested_materials,
      duration: [:hours, :minutes],
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
    column :published
    actions do |resource|
      link_to "View", resource
    end
  end

  controller do
    def new
      super do |format|
        Lesson::LEVELS.each_key do |level_id|
          @topic.admin_lessons.build(level_id: level_id)
        end
      end
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :name
      f.input :description, as: :ckeditor
      tabs do
        topic.admin_lessons.each do |lesson|
          tab lesson.level do
            render partial: "admin/lessons/fields",
                   locals: { f: f, lesson: lesson }
          end
        end
      end
    end
    f.actions
  end


  sidebar :last_updated, only: :edit do
    content_tag(:div, class: "input") do
      resource.updated_at.strftime("%b %e, %Y %l:%M%P")
    end
  end

  sidebar :topic_extras, only: :edit do
    render partial: "admin/topics/extra",
      locals: { topic: resource }
  end
end
