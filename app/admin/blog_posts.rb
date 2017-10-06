ActiveAdmin.register BlogPost do
  menu label: "Blog"
  config.sort_order = "published_at_desc"

  permit_params :name, :body, :slug

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

  index do
    selectable_column
    id_column

    column :name

    column "Original Post", :original_url do |blog|
      link_to blog.original_url, blog.original_url
    end

    column :published_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug, hint: "Leave blank to auto-generate"
      f.input :body, as: :ckeditor
    end

    f.actions
  end
end
