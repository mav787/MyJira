require 'test_helper'

class CardMailerTest < ActionMailer::TestCase
  setup do
    @card = cards(:todo_card1)
    @notification = notifications(:card_note)
    @user = users(:test_user2)
  end

  test "should send card assignment notification" do
    mail = CardMailer.add_user @user, @notification
    assert_equal "You are assigned a new card #{@card.content} on MyJira", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["myjirateam@gmail.com"], mail.from
    assert_equal ["37a91c30db1951699f0f4a4568e034a9+#{@card.id}-0@inbound.postmarkapp.com"], mail.reply_to
    assert_match @user.name, mail.body.encoded
    assert_match @card.content, mail.body.encoded
    assert_match @card.list.board.name, mail.body.encoded
    assert_match "/boards/#{@card.list.board.id}?card_id=#{@card.id}", mail.body.encoded
  end
end
