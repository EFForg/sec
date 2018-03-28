ActiveAdmin.register Page do
  menu parent: "Content"
  actions :index, :edit, :update

  index do
    column :name do |page|
      page.name.split("-").join(" ").humanize
    end
    column :updated_at
    actions
  end

  form do |f|
    inputs do
      f.input :body, as: :ckeditor
    end
  end
end
