module SocialMediaHelper
  def url_for_share
    request.original_url
  end

  def og_title
    @og_title.presence || page_title
  end

  def og_description
    @og_description.presence || "The Security Education Companion is a resource for people teaching digital security to their friends and neighbors."
  end

  def og_image
    @og_image.presence || image_url("sec-og-image.png")
  end
end
