class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_push
    repo = params["repository"]["full_name"]
    board = Board.where("repo =? ", repo).first
    done_list = List.where("board_id = ?", board.id).where("name = ?", "done").first
    params["commits"].each do |c|
      board.lists.each do |l|
        l.cards.each do |card|
          if card.content == c["message"]
            redirect_to :controller => 'card', :action => 'move', :params =>{:card_id => card.id, :new_list_id => done_list.id}
          end
        end
      end
    end
  end


  private

  def webhook_secret(payload)
    "a_gr34t_s3cr3t"
  end
end
