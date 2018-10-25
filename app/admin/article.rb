ActiveAdmin.register Article do
  include ViewingInApp

  menu parent: "Content", priority: 1

  permit_params :name, :authorship, :summary, :body, :next_article_id,
    :flag, :slug, :published

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
    column :published
    actions do |resource|
      link_to "View", resource
    end
  end

  form do |f|
    inputs do
      f.input :name
      f.input :authorship, label: "Authors"
      f.input :summary, as: :ckeditor,
              hint: "If left blank, the first ~500 characters the article body will be used."
      f.input :body, as: :ckeditor

      f.input :next_article, input_html: { class: "select2" }
    end

    f.actions do
      f.submit
      li do
        button_tag "Preview", type: "button", id: "preview", class: "btn"
      end
      f.cancel_link
    end
  end

  sidebar :last_updated, only: :edit do
    content_tag(:div, class: "input") do
      resource.updated_at.strftime("%b %e, %Y %l:%M%P")
    end
  end

  sidebar :article_extras, only: :edit do
    render partial: "admin/articles/extra",
      locals: { article: resource }
  end
end
