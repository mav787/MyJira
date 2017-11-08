class ApplicationMailer < ActionMailer::Base
  default :from => "MyJira Team <myjirateam@gmail.com>"
  layout 'mailer'
end
