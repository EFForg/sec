ActiveAdmin.register Article do
  menu priority: 4

  permit_params :name, :authorship, :body, :slug, :published

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :slug do |record|
      link_to record.slug, article_path(record)
    end
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
