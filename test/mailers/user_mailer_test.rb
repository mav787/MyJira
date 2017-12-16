require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:test_user1)
  end

  test "should send email confirmation" do
    mail = UserMailer.registration_confirmation @user
    assert_equal "Registration Confirmation", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["myjirateam@gmail.com"], mail.from
    assert_match @user.name, mail.body.encoded
  end
end
