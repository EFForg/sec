ActiveAdmin.register BlogPost do
  menu label: "Blog"

  index do
    id_column

    column :name

    column "Original Post", :original_url do |blog|
      link_to blog.original_url, blog.original_url
    end

    column :updated_at
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
