class MaterialsUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def convert_to_image(height, width)
    manipulate! do |image|
      image.resize "#{height}x#{width}"
      image.format "png"
    end
  end

  version :thumbnail, if: :is_previewable? do
    process resize_to_fit: [210, 297], if: :is_image?
    process convert_to_image: [210, 297], if: :is_pdf?

    def full_filename(filename = model.source.file)
      "thumb_#{filename.sub(/\.pdf\z/, ".jpg")}"
    end
  end

  private
  def is_image?(file)
    content_type.include? "image"
  end

  def is_pdf?(file)
    content_type == "application/pdf"
  end

  def is_previewable?(file)
    is_image?(file) || is_pdf?(file)
  end
end
