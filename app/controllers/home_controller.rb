class HomeController < ApplicationController
  def index
    @homepage = Homepage.take
  end
end
