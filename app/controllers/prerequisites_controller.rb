class PrerequisitesController < ApplicationController

  def add
    new_precard = Card.find(params[:toaddcard_id])
    card = Card.find(params[:card_id])
    Prerequisite.create(card_id:params[:card_id],precard_id:params[:toaddcard_id])
    ActionCable.server.broadcast "team_#{card.list.board.id}_channel",
                                 event: "add_prereq_to_card",
                                 card_id: params[:card_id],
                                 precard_id: new_precard.id,
                                 precard_content: new_precard.content
                                 isdone: new_precard.list_id == 3? "Y": "N";
    respond_to do |format|
      format.json { render json: {status: "success",precard_id: params[:toaddcard_id]}}
    end
  end

  def delete
    todel_precard = Card.find(params[:todeletecard_id])
    card = Card.find(params[:card_id])
    Prerequisite.delete(Prerequisite.where(card_id:params[:card_id],precard_id:params[:todeletecard_id]).first.id)
    ActionCable.server.broadcast "team_#{card.list.board.id}_channel",
                                 event: "delete_prereq_from_card",
                                 card_id: params[:card_id],
                                 precard_id: todel_precard.id,
                                 precard_content: todel_precard.content
    respond_to do |format|
      format.json { render json: {status: "success",precard_id: params[:todeletecard_id]}}
    end
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
