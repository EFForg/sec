module UploadsHelper
  def full_preview(file)
    return if file.blank?

    if file.full_preview.url
      preview = image_tag(file.full_preview.url)
    else
      preview = fallback(file)
    end

    link_to preview, file.url, class: "file-preview"
  end

  def thumbnail(file)
    return if file.blank?

    if file.thumbnail.url
      preview = image_tag(file.thumbnail.url)
    else
      preview = fallback(file)
    end

    link_to preview, file.model.material, class: "file-preview"
  end

  def fallback(file)
    content_tag :div, class: "file-preview-fallback" do
      content_tag(:span, ".#{file.file.extension.downcase}")
    end
  end

  def file_name(file)
    File.basename(file.path)
  end
end
