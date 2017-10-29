class PrerequisitesController < ApplicationController

  def add
    Prerequisite.create(card_id:params[:card_id],precard_id:params[:toaddcard_id])
    redirect_to prerequisites_index_path(card_id:params[:card_id])


  end

  def delete
    Prerequisite.delete(Prerequisite.where(card_id:params[:card_id],precard_id:params[:todelete_id]).first.id)
    redirect_to prerequisites_index_path(card_id:params[:card_id])
  end


  def index
    @card = Card.find(params[:card_id])
    @precards = @card.precards
    @notprecards = []
    Card.all.each do |card|
      if (card != @card && ! card.in?(@precards) && List.find(card.list_id).board_id == List.find(@card.list_id).board_id)
        @notprecards.push(card)
      end
    end

  end
end
