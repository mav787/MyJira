class CommentMailer < ActionMailer::Base
  default :from => "MyJira Team <myjirateam@gmail.com>"

    def comment_note(user, note)
      @user = user
      @note = note
      mail(:to => "#{user.name} <#{user.email}>", :subject => "#{note.comment.from_user.name} sent you a new comment on MyJira")
   end

end
