class CreditsController < ApplicationController
  def index
    @page = Page.find_by(name: "credits")
  end
end
