class MaterialsController < ApplicationController
  include ContentPermissioning

  breadcrumbs "Security Education" => routes.root_path,
              "Training Materials" => routes.materials_path

  def index
    @page = Page.find_by!(name: "materials-overview")
    @materials = Material.published.page(params[:page])
  end

  def show
    @material = Material.friendly.find(params[:id])
    protect_unpublished! @material
    og_object @material

    @topics = Topic.joins(:lessons).
      where("lessons.suggested_materials LIKE ?",
            "%#{ material_path(@material) }%")
  end
end
