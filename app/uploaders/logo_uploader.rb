class LogoUploader < MediaUploader
  version :main do
    process :resize_to_fill => [1440, 500]
  end

  version :widget do
    process :resize_to_fit => [200,75]
  end
end