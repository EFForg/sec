ActiveAdmin.register Material do
  include ViewingInApp

  menu parent: "Content", priority: 3

  permit_params :name, :description, :slug, :published, :third_party,
    uploads_attributes: [:id, :_destroy, :name, :description, :position, :file]


  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    column :name
    column :published
    column :third_party
    actions do |resource|
      link_to "View", resource
    end
  end

  form do |f|
    inputs do
      f.input :name
      f.input :description, as: :ckeditor
      f.has_many :uploads, sortable: :position,
                           allow_destroy: true do |u|
        u.input :name
        u.input :description
        u.input :file, as: :file, hint: full_preview(u.object.file)
      end
    end

    f.actions
  end


  sidebar :material_extras, only: :edit do
    render partial: "admin/materials/extra",
      locals: { material: resource }
  end
end
