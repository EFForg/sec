module ActiveAdmin::AdminHelper
  def reorderable_inputs(label, assoc, f:)
    f.inputs label, class: "inputs reorderable" do
      f.fields_for(assoc) do |sf|
        yield sf
        sf.input :position, as: :hidden
      end
    end
  end

  def tags_collection
    ActsAsTaggableOn::Tag.order(:name).select(:id, :name)
  end

  def articles_overview_react_props(page)
    {
      "sections" => page.sections.as_json(
        only: [:id, :name],
        include: {
          articles: {
            only: [:id, :name]
          }
        }
      ),

      "articles" => Article.published.as_json(only: [:id, :name])
    }
  end
end
