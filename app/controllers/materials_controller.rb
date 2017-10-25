class MaterialsController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Training Materials" => routes.materials_path

  def index
    @materials = Material.all.page(params[:page])
  end

  def show
    @material = Material.find(params[:id])
    @topics = Topic.joins(lessons: :materials).
               where(materials: { id: @material.id })
  end
end
