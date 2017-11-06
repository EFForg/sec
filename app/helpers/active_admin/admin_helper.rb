module ActiveAdmin::AdminHelper
  def reorderable_inputs(label, assoc, f:)
    f.inputs label, class: "inputs reorderable" do
      f.fields_for(assoc) do |sf|
        yield sf
        sf.input :position, as: :hidden
      end
    end
  end
end
