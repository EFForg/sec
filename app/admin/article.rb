ActiveAdmin.register Article do
  permit_params :name, :body, :slug

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  form do |f|
    inputs do
      f.input :name
      f.input :slug, hint: "Leave blank to auto-generate"
      f.input :body, as: :ckeditor
    end

    f.actions
  end
end
