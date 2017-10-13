module MaterialsHelper
  def file_preview(attachment)
    return if attachment.nil?
    if attachment.image?
      image_tag(attachment.url)
    # We can add more preview goodness here as we add previews of other file types
    else
      "Currently uploaded: #{File.basename(attachment.path)}"
    end
  end
end
