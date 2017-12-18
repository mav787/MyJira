class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    author = User.find_by_email(@email.from[:email])
    token_items = @email.to.first[:token].match(/\+(.*)-(.*)/i)
    token_task_id, token_recipient_id = token_items.captures
    card = Card.find(token_task_id)
    board = card.list.board
    done_list = List.where("board_id = ? and name = ?", board.id, "done").first
    done_list = List.where("board_id = ? and name = ?", board.id, "doing").first

    if (token_recipient_id != "0")
      comment = Comment.create(context: @email.body, from_user_id: author.id, card_id: token_task_id, to_user_id: token_recipient_id)
      n = Notification.create(recipient_id: token_recipient_id, comment_id: comment.id, card_id: token_task_id, read: false, source: "comment")
      CommentMailer.comment_note(n.recipient, n).deliver
    else
      if @email.body.start_with?("done") && card.list.name == "doing"
        card.list_id = done_list.id
        card.finished_at = Time.now
        card.card_order = 1
        card.save
        new_list_cards = Card.where("list_id = ? AND card_order >= ?", done_list.id, 1).where.not(id:card.id)
        new_list_cards.each do |nc|
          nc.card_order += 1
          nc.save
        end
        ActionCable.server.broadcast "team_#{board.id}_channel",
                                     card_id: token_task_id,
                                     list_id: done_list.id,
                                     order: 1

      elsif @email.body.start_with?("doing")
        card.list_id = doing_list.id
        card.startdate = Time.now
        card.card_order = 1
        card.save
        new_list_cards = Card.where("list_id = ? AND card_order >= ?", doing_list.id, 1).where.not(id:card.id)
        new_list_cards.each do |nc|
          nc.card_order += 1
          nc.save
        end
        ActionCable.server.broadcast "team_#{board.id}_channel",
                                     card_id: token_task_id,
                                     list_id: doing_list.id,
                                     order: 1
     end
   end
  end
end
