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

  version :full_preview, if: :is_previewable? do
    def full_filename(filename = model.source.file)
      "preview_#{filename.sub(/\.pdf\z/, ".png")}"
    end
  end

  version :thumbnail, if: :is_previewable? do
    process crop_square: 210
    process convert: "png", if: :is_pdf?

    def full_filename(filename = model.source.file)
      "thumb_#{filename.sub(/\.pdf\z/, ".png")}"
    end
  end

  private
  def is_pdf?(file)
    content_type == "application/pdf"
  end

  def is_previewable?(file)
    content_type.include?("image") || is_pdf?(file)
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

  def crop_square(size)
    if @file.content_type == "image/gif"
      original = MiniMagick::Image.new(@file.path)
      gif_safe_transform! do |image|
        imagemagick_do_crop(image, size, original.width, original.height)
      end
    else
      manipulate! do |image|
        imagemagick_do_crop(image, size, image.width, image.height)
      end
    end
  end

  def imagemagick_do_crop(image, size, orig_width, orig_height)
    if orig_width < orig_height
      remove = ((orig_height - orig_width)/2).round
      image.shave("0x#{remove}")
    elsif orig_width > orig_height
      remove = ((orig_width - orig_height)/2).round
      image.shave("#{remove}x0")
    end
    image.resize("#{size}x#{size}")
  end
end
