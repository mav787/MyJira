require 'test_helper'

class BoardMailerTest < ActionMailer::TestCase
  setup do
    @board = boards(:one)
    @notification = notifications(:board_note)
    @user = users(:test_user2)
  end

  test "should send board notification" do
    mail = BoardMailer.enroll_note @user, @notification
    assert_equal "You're invited to join board #{@notification.board.name} on MyJira", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["myjirateam@gmail.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @board.name, mail.body.encoded
    assert_match "/boards/#{@board.id}", mail.body.encoded
  end
end
