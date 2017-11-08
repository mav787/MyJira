class UserMailerPreview < ActionMailer::Preview

  def registration_confirmation
    UserMailer.registration_confirmation(User.first)
  end
end
