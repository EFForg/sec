class MaterialsController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Training Materials" => routes.materials_path

  def index
    @materials = Material.all.page(params[:page])
  end

  def show
  end
end
