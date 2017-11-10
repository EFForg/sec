class HomeController < ApplicationController
  def index
    @page = Page.find_by!(name: "homepage")
  end
end
