class NotificationsMailer < ActionMailer::Base

  default :from => "bracketbook contact form"
  default :to => "travis@travisluong.com"

  def new_message(message)
    @message = message
    mail(:subject => "[bracketbook.com] #{message.subject}")
  end

end
