class ErrorsController < ApplicationController
  def not_found
    render status: 404 # rubocop:disable GitHub/RailsControllerRenderLiteral
  end

  def unacceptable
    render "errors/internal_error", status: 422
  end

  def internal_error
    render status: 500 # rubocop:disable GitHub/RailsControllerRenderLiteral
  end
end
