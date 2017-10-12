ActiveAdmin.register ActsAsTaggableOn::Tag, as: "tag" do
  menu priority: 6

  index do
    selectable_column
    id_column
    column :name
    column "Taggings", :taggings_count
    actions
  end
end
