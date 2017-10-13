class MaterialsAttachmentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

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

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def is_image?
    content_type.include? "image"
  end

  def is_previewable?
    content_type == "application/pdf" || content_type == "text/plain"
  end

  def convert_to_image(height, width)
    image = ::Magick::Image.read(current_path + "[0]")[0]
    image.resize_to_fit(height, width)

    # Put it on a white background.
    canvas = ::Magick::Image.new(image.columns, image.rows) { self.background_color = "#FFF" }
    canvas.composite!(image, ::Magick::CenterGravity, ::Magick::OverCompositeOp)
    canvas.write(current_path)

    # Free memory allocated by RMagick which isn't managed by Ruby
    image.destroy!
    canvas.destroy!
  rescue ::Magick::ImageMagickError => e
    Rails.logger.error "Failed to create PDF thumbnail: #{e.message}"
    raise CarrierWave::ProcessingError, "is not a valid PDF file"
  end

  version :preview do
    process :convert_to_image => [310, 438]
    process :convert => :jpg

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end
end
