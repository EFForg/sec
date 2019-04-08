module UploadsHelper
  def full_preview(file)
    return if file.blank?

    if file.full_preview.url
      image_tag(file.full_preview.url, alt: "")
    else
      fallback(file)
    end
  end

  def thumbnail(file)
    return if file.blank?

    if file.thumbnail.url
      image_tag(file.thumbnail.url, alt: "")
    else
      fallback(file)
    end
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
