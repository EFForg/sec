
if Rails.application.routes.relative_url_root
  Rails.application.routes.default_url_options = {
    script_name: Rails.application.routes.relative_url_root
  }
end
