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

  def convert_to_image(height, width)
    manipulate! do |image|
      image.resize "#{height}x#{width}"
      image.format "png"
    end
  end

  version :full_preview, if: :is_previewable? do
    process resize_to_limit: [210, nil], if: :is_image?
    process convert_to_image: [210, 297], if: :is_pdf?

    def full_filename(filename = model.source.file)
      "preview_#{filename.sub(/\.pdf\z/, ".jpg")}"
    end
  end

  version :thumbnail, from_version: :full_preview, if: :is_previewable? do
    process resize_to_fill: [210, 210]

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
