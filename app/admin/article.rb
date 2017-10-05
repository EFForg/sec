ActiveAdmin.register Article do
  permit_params :name, :body

  form do |f|
    inputs do
      f.input :name

      f.input :body, as: :ckeditor
    end

    f.actions
  end
end
