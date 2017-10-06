ActiveAdmin.register BlogPost do
  menu label: "Blog"
  config.sort_order = "published_at_desc"

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
      f.input :body, as: :ckeditor
    end

    f.actions
  end
end
