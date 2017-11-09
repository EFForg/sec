class MaterialsController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Training Materials" => routes.materials_path

  def index
    @page = Page.find_by!(name: "materials-overview")
    @materials = Material.all.page(params[:page])
  end

  def show
    @material = Material.find(params[:id])
    @topics = Topic.joins(:lessons).
      where("lessons.suggested_materials LIKE ?",
            "%#{ material_path(@material) }%")
  end
end
