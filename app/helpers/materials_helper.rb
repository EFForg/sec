module MaterialsHelper
  def file_preview(attachment)
    return if attachment.nil?
    if attachment.is_image?
      image_tag(attachment.url)
    # We can add more preview goodness here as we add previews of other file types
    elsif attachment.is_previewable?
      image_tag(attachment.preview.url)
    else
      "Currently uploaded: #{File.basename(attachment.path)}"
    end
  end
end
