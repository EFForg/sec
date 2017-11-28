module Pdfing
  extend ActiveSupport::Concern

  def url_options
    if rendered_format.symbol == :pdf
      {
        host: ENV["SERVER_NAME"] || "localhost",
        port: Rails.env.production? ? 80 : 3000,
        protocol: ENV["SERVER_PROTOCOL"] || "http"
      }
    else
      super
    end
  end
end
