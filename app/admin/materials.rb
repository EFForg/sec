ActiveAdmin.register Material do
  permit_params :name, :body, :attachment

  index do
    id_column
    column :name

    column "Attached File", :attachment_file_name do |material|
      link_to material.attachment_file_name, material.attachment.url,
              target: "_blank"
    end

    column :attachment_updated_at
    actions
  end

  form do |f|
    inputs do
      f.input :name
      f.input :body, label: "Description", as: :ckeditor

      f.input :attachment
    end

    f.actions
  end
end
