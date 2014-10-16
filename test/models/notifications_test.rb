require_relative '../test_helper'

describe Notification do
  before do
    @recipient = Fabricate :user
    @notification = @recipient.notify! "Test notification"
  end

  it "registers on the user side" do
    @recipient.notifications.current.must_include @notification
  end

  it "sent an email" do
    must_receive_email to: @recipient.email, 
                       subject: "[Before the Banners] New notification received"
  end

  it "defaults to unviewed" do
    @notification.wont_be :viewed?
  end
end