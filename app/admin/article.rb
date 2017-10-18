ActiveAdmin.register Article do
  menu priority: 4

  permit_params :name, :authorship, :body, :slug, :published

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  filter :name
  filter :body
  filter :tags
  filter :created_at
  filter :updated_at
  filter :slug

  index do
    selectable_column
    column :name
    column :published_at
    actions
  end

  form do |f|
    inputs do
      f.input :name
      f.input :authorship, label: "Authors"
      f.input :body, as: :ckeditor
    end

    f.actions
  end


  sidebar :article_extras, only: :edit do
    render partial: "admin/articles/extra",
      locals: { article: resource }
  end
end
