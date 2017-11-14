module UploadsHelper
  def file_preview(file)
    return if file.blank?
    return image_tag(file.thumbnail.url) if file.thumbnail.url

    content_tag :div, class: "file-preview-fallback" do
      content_tag(:span, ".#{file.file.extension.downcase}")
    end
  end


  def file_name(file)
    File.basename(file.path)
  end
end
