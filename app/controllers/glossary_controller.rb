class GlossaryController < ApplicationController
  def index
    @terms = GlossaryTerm.order(:name)
  end

  def show
    @term = GlossaryTerm.friendly.find(params[:id])
  end
end
