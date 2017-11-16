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

  def make_png
    manipulate! do |image|
      image.format "png"
    end
  end

  def convert_to_cropped_square(size)
    manipulate! do |image|
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
    process resize_to_limit: [210, nil], if: :is_image?
    process convert_to_image: [210, 297], if: :is_pdf?

    def full_filename(filename = model.source.file)
      "preview_#{filename.sub(/\.pdf\z/, ".png")}"
    end
  end

  version :thumbnail, if: :is_previewable? do
    process convert_to_cropped_square: 210
    process make_png: [], if: :is_gif?
    process make_png: [], if: :is_pdf?

    def full_filename(filename = model.source.file)
      "thumb_#{filename.sub(/\.pdf\z/, ".png").sub(/\.gif\z/, ".png")}"
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
