ActiveAdmin.register GlossaryTerm do
  menu label: "Glossary", priority: 4

  filter :name
  config.sort_order = "name_asc"

  index do
    selectable_column
    column :name
    column :synonyms do |term|
      term.synonyms.join(", ")
    end

    actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  permit_params :name, :body, :synonyms_list

  form do |f|
    input_html = f.object.new_record? ? {} : { disabled: true }

    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :name, input_html: input_html
      f.input :body, as: :ckeditor
      f.input :synonyms_list
    end

    f.actions
  end
end
