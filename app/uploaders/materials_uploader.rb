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

  def gif_safe_transform!
    MiniMagick::Tool::Convert.new do |image|
      image << @file.path
      image.coalesce

      yield image

      image.layers "Optimize"
      image << @file.path
    end
  end

  def crop_square(image, size, orig_width, orig_height)
    if orig_width < orig_height
      remove = ((orig_height - orig_width)/2).round
      image.shave("0x#{remove}")
    elsif orig_width > orig_height
      remove = ((orig_width - orig_height)/2).round
      image.shave("#{remove}x0")
    end
    image.resize("#{size}x#{size}")
  end

  def mogrify_crop_square(size)
    manipulate! do |image|
      crop_square(image, size, image.width, image.height)
    end
  end

  def gif_crop_square(size)
    original = MiniMagick::Image.new(@file.path)

    gif_safe_transform! do |image|
      crop_square(image, size, original.width, original.height)
    end
  end

  version :full_preview, if: :is_previewable? do
    def full_filename(filename = model.source.file)
      "preview_#{filename.sub(/\.pdf\z/, ".png")}"
    end
  end

  version :thumbnail, if: :is_previewable? do
    process gif_crop_square: 210, if: :is_gif?
    process mogrify_crop_square: 210, if: :is_not_gif?
    process convert: "png" # Only applied to files with .png extension

    def full_filename(filename = model.source.file)
      # Give PDFs a .png extension so they get converted.
      "thumb_#{filename.sub(/\.pdf\z/, ".png")}"
    end
  end

  private
  def is_gif?(file)
    content_type == "image/gif"
  end

  def is_not_gif?(file)
    !is_gif?(file)
  end

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
