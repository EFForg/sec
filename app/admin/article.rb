ActiveAdmin.register Article do
  menu priority: 4

  permit_params :name, :body, :slug, :published

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    column :name
    column :published_at
    actions
  end

  form do |f|
    inputs do
      f.input :name
      f.input :body, as: :ckeditor
    end

    f.actions
  end


  sidebar :article_extras, only: :edit do
    render partial: "admin/articles/extra",
      locals: { article: resource }
  end
end
