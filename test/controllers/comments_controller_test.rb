require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
  end

  test "should create comment and notification too" do
   log_in_as users(:test_user1)
    assert_difference(['Comment.count', 'Notification.count']) do
     post comments_url, params: { comment: { card_id: @comment.card_id, context: @comment.context, to_user_id: @comment.to_user_id } }
    end
  end
end
