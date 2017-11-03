module UploadsHelper
  def file_preview(file)
    return if file.blank?

    if file.thumbnail.url
      image_tag(file.thumbnail.url)
    else
      "Currently uploaded: #{file_name(file)}"
    end
  end

  def file_name(file)
    File.basename(file.path)
  end
end
