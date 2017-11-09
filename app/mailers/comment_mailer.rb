class CommentMailer < ActionMailer::Base
  default :from => "MyJira Team <myjirateam@gmail.com>"

  def comment_note(user, note)
      @user = user
      @note = note
      mail(:to => "#{user.name} <#{user.email}>",
     :reply_to => "37a91c30db1951699f0f4a4568e034a9+#{note.card.id}-#{note.comment.from_user.id}@inbound.postmarkapp.com",
     :subject => "#{note.comment.from_user.name} sent you a new comment on MyJira")
   end

end
