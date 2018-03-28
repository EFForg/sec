module PdfHelper
  def page_break
    content_tag(:div, "", class: "page-break")
  end
end
