class CardMailer < ActionMailer::Base
  default :from => "MyJira Team <myjirateam@gmail.com>"

  def add_user(user, note)
      @user = user
      @note = note
      mail(:to => "#{user.name} <#{user.email}>",
     :reply_to => "37a91c30db1951699f0f4a4568e034a9+#{note.card.id}-0@inbound.postmarkapp.com",
     :subject => "You are assigned a new card #{note.card.content} on MyJira")
   end

end
