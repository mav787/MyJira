require 'test_helper'

class CommentMailerTest < ActionMailer::TestCase
  setup do
    @comment = comments(:one)
    @notification = notifications(:comment_note)
    @user = users(:test_user2)
  end

  test "should send comment notification" do
    mail = CommentMailer.comment_note @user, @notification
    assert_equal "#{@comment.from_user.name} sent you a new comment on MyJira", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["myjirateam@gmail.com"], mail.from
    assert_equal ["37a91c30db1951699f0f4a4568e034a9+#{@notification.card.id}-#{@comment.from_user.id}@inbound.postmarkapp.com"], mail.reply_to
    assert_match @user.name, mail.body.encoded
    assert_match @comment.context, mail.body.encoded
    assert_match @comment.card.content, mail.body.encoded
    assert_match "/boards/#{@comment.card.list.board.id}?card_id=#{@comment.card.id}", mail.body.encoded
  end
end
