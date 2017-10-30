ActiveAdmin.register ActsAsTaggableOn::Tag, as: "tag" do
  menu parent: "Content", priority: 5

  permit_params :name

  filter :name

  index do
    selectable_column
    column :name
    column "Taggings", :taggings_count
    actions
  end
end
