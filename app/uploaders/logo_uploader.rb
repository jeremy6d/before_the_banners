class LogoUploader < MediaUploader
  version :main do
    process :resize_to_fill => [1440, 500]
    process :convert_to_grayscale
  end

  version :thumbnail do
    process :resize_to_fill => [450,160]
  end

  version :widget do
    process :resize_to_fit => [200,75]
  end

  def convert_to_grayscale
    manipulate! do |img|
      img.colorspace("Gray")
      img.brightness_contrast("10x-30")
      img.alpha 'remove'
      img = yield(img) if block_given?
      img
    end
  end
end