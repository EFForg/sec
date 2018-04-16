module PdfHelper
  def page_break
    content_tag(:div, "", class: "page-break")
  end

  def asset_data_uri(path)
    asset = Rails.application.assets.find_asset(path)
    data = Base64.encode64(asset.source)
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(data)}"
  end

  def pdf_style_sheet
    content_tag(:style, type: "text/css") do
      Rails.application.assets.find_asset("pdf.scss").to_s.html_safe
    end
  end
end
