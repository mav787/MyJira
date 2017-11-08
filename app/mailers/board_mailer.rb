class BoardMailer < ActionMailer::Base
  default :from => "MyJira Team <myjirateam@gmail.com>"

  def enroll_note(user, note)
    @user = user
    @note = note
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "#{note.board.leader.name} invited you to join board #{note.board.name}")
 end

end
