ActiveAdmin.register BlogPost do
  menu label: "Blog", priority: 5

  config.sort_order = "published_at_desc"

  permit_params :name, :authorship, :body, :slug, :published, tag_ids: []

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  collection_action :import, method: :post do
    UpdateBlogPost.perform_now params[:deeplinks_url]
    redirect_to admin_blog_posts_path
  end

  sidebar :import_post_from_deeplinks, only: :index do
    form(action: import_admin_blog_posts_path, method: :post) do |f|
      f.input name: "authenticity_token", type: "hidden", value: form_authenticity_token

      f.fieldset(class: "input string") do
        f.label "URL", for: "deeplinks_url"
        f.input name: :deeplinks_url
      end

      f.fieldset(class: "buttons") do
        f.input "Import Post", type: "submit"
      end
    end
  end

  filter :name
  filter :body
  filter :original_url
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
    f.inputs do
      f.input :name
      f.input :authorship, label: "Authors"
      f.input :body, as: :ckeditor
    end

    f.actions
  end

  sidebar :blog_post_extras, only: :edit do
    render partial: "admin/blog_posts/extra",
      locals: { blog_post: resource }
  end
end
