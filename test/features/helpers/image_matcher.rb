class ImageMatcher
  def initialize(fn)
    @filename = fn
  end

  def matches? page
    page.has_xpath? "//img[contains(@src, \"#{@filename}\")]"
  end

  def failure_message_for_should
    "expected to find an image tag for #{@filename}"
  end

  def failure_message_for_should_not
    "expected not to find an image tag for #{@filename}"
  end
end

def contain_image_for(in_fn)
  ImageMatcher.new(in_fn)
end

Capybara::Rails::TestCase.register_matcher :contain_image_for, :contain_image_for