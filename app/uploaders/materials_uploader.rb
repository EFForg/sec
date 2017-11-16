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

  def make_preview
    manipulate! do |image|
      if image.mime_type == "image/gif"
        image.collapse!
      end

      yield image

      if image.mime_type == "image/pbm"
        image.format "png"
      end

      image
    end
  end

  def make_resized_preview(width)
    make_preview do |image|
      height = (width.to_f/image[:width])*image[:height]
      height = height.round
      image.resize "#{width}x#{height}"
    end
  end

  def make_square_preview(size)
    make_preview do |image|
      if image[:width] < image[:height]
        remove = ((image[:height] - image[:width])/2).round
        image.shave("0x#{remove}")
      elsif image[:width] > image[:height]
        remove = ((image[:width] - image[:height])/2).round
        image.shave("#{remove}x0")
      end
      image.resize("#{size}x#{size}")
    end
  end

  version :full_preview, if: :is_previewable? do
    process make_resized_preview: 210

    def full_filename(filename = model.source.file)
      "preview_#{filename.sub(/\.pdf\z/, ".png")}"
    end
  end

  version :thumbnail, if: :is_previewable? do
    process make_square_preview: 210

    def full_filename(filename = model.source.file)
      "thumb_#{filename.sub(/\.pdf\z/, ".png")}"
    end
  end

  private
  def is_image?(file)
    content_type.include? "image"
  end

  def is_gif?(file)
    content_type == "image/gif"
  end

  def is_pdf?(file)
    content_type == "application/pdf"
  end

  def is_previewable?(file)
    is_image?(file) || is_pdf?(file)
  end
end
