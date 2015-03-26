CarrierWave.configure do |config|
  if Rails.env.production?
	  config.storage = :fog
	  config.fog_credentials = {
	    :provider               => 'AWS',                        # required
	    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],                        # required
	    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],                        # required
	    :region                 => 'us-east-1',                  # optional, defaults to 'us-east-1'
	  }
	  config.fog_directory  = 'beforethebanners'                          # required
	  config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
  else
    config.storage = :file
    # config.root = Rails.root.join('tmp')
    # config.cache_dir = "uploads"
  end
end