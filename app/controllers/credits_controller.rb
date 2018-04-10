class CreditsController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Credits" => routes.credits_path

  def index
    @page = Page.find_by(name: "credits")
  end
end
