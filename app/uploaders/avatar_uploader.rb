class AvatarUploader < MediaUploader
  version :formatted do
    process :resize_to_fit => [300, 300]
  end
end