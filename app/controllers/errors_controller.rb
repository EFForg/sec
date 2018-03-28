class ErrorsController < ApplicationController
  def not_found
    render "errors/not_found.html.erb", status: 404
  end

  def unacceptable
    render "errors/internal_error.html.erb", status: 422
  end

  def internal_error
    render "errors/internal_error.html.erb", status: 500
  end
end
