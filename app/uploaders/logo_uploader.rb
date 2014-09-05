class LogoUploader < MediaUploader
  version :formatted do
    process :resize_to_fit => [nil, 200]
  end
end