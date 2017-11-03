ActiveAdmin.register Material do
  include ViewingInApp

  menu parent: "Content", priority: 3

  permit_params :name, :description,
    uploads_attributes: [:id, :name, :description, :position, :file]

  index do
    selectable_column
    column :name
    actions do |resource|
      link_to "View", resource
    end
  end

  form do |f|
    inputs do
      f.input :name
      f.input :description, as: :ckeditor
      f.has_many :uploads, sortable: :position,
                           allow_destory: true do |u|
        u.input :name
        u.input :description
        u.input :file, as: :file, hint: file_preview(u.object.file)
      end
    end

    f.actions
  end
end
