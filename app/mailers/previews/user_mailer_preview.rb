class UserMailerPreview < ActionMailer::Preview

  def registration_confirmation
    UserMailer.registration_confirmation(User.find(6))
  end
end
