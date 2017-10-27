class ErrorsController < ApplicationController
  def not_found
    render status: 404
  end

  def unacceptable
    render status: 422, template: "errors/internal_error"
  end

  def internal_error
    render status: 500
  end
end
