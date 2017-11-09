class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    # all of your application-specific code here - creating models,
    # processing reports, etc

    author = User.find_by_email(@email.from[:email])

    token_items = @email.to.first[:token].match(/\+(.*)-(.*)/i)
    token_task_id, token_recipient_id = token_items.captures

    comment = Comment.create(context: @email.body, from_user_id: author.id, card_id: token_task_id, to_user_id: token_recipient_id)
    n = Notification.create(recipient_id: token_recipient_id, comment_id: comment.id, card_id: token_task_id, read: false, source: "comment")
    CommentMailer.comment_note(n.recipient, n).deliver
  end
end
