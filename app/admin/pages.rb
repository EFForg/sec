ActiveAdmin.register Page do
  actions :index, :edit, :update

  permit_params :body

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

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

    f.actions
  end
end
