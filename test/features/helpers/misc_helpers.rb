module FeatureHelpers
  module MiscHelpers
    def a_file_named filename
      File.open(File.join(Rails.root, "test", "fixtures", filename), "r")
    end
  end
end