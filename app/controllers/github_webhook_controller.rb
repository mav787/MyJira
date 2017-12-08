class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_push
    repo = params["repository"]["full_name"]
    board = Board.where("repo =? ", repo).first
    done_list = List.where("board_id = ?", board.id).where("name = ?", "done").first
    doing_list = List.where("board_id = ?", board.id).where("name = ?", "doing").first
    params["commits"].each do |c|
      doing_list.cards.each do |card|
        if card.content == c["message"]
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
                                       card_id: card.id,
                                       list_id: done_list.id,
                                       order: 1
        end
      end
    end
  end


  private

  def webhook_secret(payload)
    "a_gr34t_s3cr3t"
  end
end
