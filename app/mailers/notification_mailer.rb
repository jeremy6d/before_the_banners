class NotificationMailer < ActionMailer::Base
  default from: "do-not-reply@beforethebanners.com"

  def email notification
    mail  to:           notification.recipient.email,
          body:         notification.text,
          content_type: "text/html",
          subject:      "[Before the Banners] New notification received"
  end
end