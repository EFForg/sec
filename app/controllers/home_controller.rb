class HomeController < ApplicationController
  def index
    @homepage = Homepage.new
  end
end

