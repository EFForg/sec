module MaterialsHelper
  def file_preview(attachment)
    return if attachment.nil?
    if attachment.thumbnail.url
      image_tag(attachment.thumbnail.url)
    else
      "Currently uploaded: #{File.basename(attachment.path)}"
    end
  end
end
