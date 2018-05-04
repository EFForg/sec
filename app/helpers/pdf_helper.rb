module PdfHelper
  def page_break
    content_tag(:div, "", class: "page-break")
  end

  def asset_data_uri(asset)
    asset_data = get_asset(asset)
    data = Base64.encode64(asset_data.source)
    "data:#{asset_data.content_type};base64,#{Rack::Utils.escape(data)}"
  end

  def pdf_style_sheet
    asset_data = get_asset("pdf.css")
    content_tag(:style, type: "text/css") do
      asset_data.source.html_safe # rubocop:disable Rails/OutputSafety
    end
  end

  def get_asset(asset)
    if Rails.application.config.assets.compile
      Rails.application.assets.find_asset(asset)
    else
      path = compute_asset_path(asset).remove(%r{^/})
      OpenStruct.new(
        source: File.read(Rails.root.join("public", path)),
        content_type: Rack::Mime.mime_type(File.extname(path))
      )
    end
  end
end
