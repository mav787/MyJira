class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    if logged_in?
      # @cards = Card.paginate(page: params[:page])
      @cards = Card.all
      # @cards = []
      # current_user.boards.each do |board|
      #   board.lists.each do |list|
      #     list.cards.each do |card|
      #       @cards.push(card)
      #     end
      #   end
      # end
    else
      @cards = []
    end
    respond_to do |format|
      format.html
      format.csv { send_data @cards.to_csv }
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    if current_user != nil
      notes = current_user.notifications.where(card_id: @card.id)
      if (notes != nil)
        notes.each do |note|
          note.update(read: true)
        end
      end
    end
  end

  def show_modal
    @card = Card.find(params["card_id"])
    if current_user != nil
      notes = current_user.notifications.where(card_id: @card.id)
      if (notes != nil)
        notes.each do |note|
          note.update(read: true)
        end
      end
      ActionCable.server.broadcast "#{current_user.id}_channel", event: "read_card"
    end
    card_attributes = @card.as_json
    card_attributes['tags'] = @card.tags.as_json
    card_attributes['members'] = @card.users.as_json
    card_attributes['comments'] = @card.comments.as_json
    card_attributes['comments'].each do |comment|
      comment['from_user_name'] = User.find(comment['from_user_id'].to_i).name
      if comment['to_user_id'] != nil
        comment['to_user_name'] = User.find(comment['to_user_id'].to_i).name
      end
    end
    respond_to do |format|
      format.json { render json: card_attributes}
    end
  end

  # GET /cards/new
  def new
    @card = Card.new
    if (params[:list_id][0] <= '9')
      params_list_id = params[:list_id]
    else
      params_list_id = List.where(name:params[:list_id]).first.id
    end
    @list = List.find(params_list_id)
  end

  # GET /cards/1/edit
  def edit
    @list = @card.list
  end

  # POST /cards
  # POST /cards.json
  def create
    pars = params[:card]
    @card = Card.new(card_params)
    @card.card_order = Card.where(list_id:params[:card][:list_id]).count+1
    @board = Board.find(List.find(pars[:list_id]).board.id)
    respond_to do |format|
      if @card.save
        ActionCable.server.broadcast "team_#{@card.list.board.id}_channel",
                             event: "create_card",
                             card: @card,
                             tag: @card.tags,
                             list:@card.list
        format.html { redirect_to @board, notice: 'Card was successfully created.' }
        format.json { render json: {list_id:@card.list.id}}
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    if (params[:new_list_id][0] <= '9')
      params_list_id = params[:new_list_id]
    else
      params_list_id = List.where(name:params[:new_list_id]).first.id
    end
    moving_card = Card.find(params[:card_id])
    origin_list_cards = Card.where("list_id = ? AND card_order > ?", moving_card.list_id, moving_card.card_order)
    origin_list_cards.each do |card|
      card.card_order -= 1
      card.save
    end
    old_list = moving_card.list
    new_list = List.find(params_list_id)
    if new_list.name == 'done'
      moving_card.finished_at = Time.now
    elsif old_list.name == 'done'
      moving_card.finished_at = nil
    end
    moving_card.card_order = params[:new_position]
    moving_card.list_id = params_list_id
    if new_list.name == 'doing'
       moving_card.startdate = Time.now
    end
    moving_card.save
    new_list_cards = Card.where("list_id = ? AND card_order >= ?", moving_card.list_id, moving_card.card_order).where.not(id:moving_card.id)
    new_list_cards.each do |card|
      card.card_order += 1
      card.save
    end
    #$("div[card_id='1']")
    ActionCable.server.broadcast "team_#{moving_card.list.board.id}_channel",
                                 event: "move_card",
                                 card_id: moving_card.id,
                                 list_id: moving_card.list.id,
                                 order: moving_card.card_order
    respond_to do |format|
      format.js{}
    end
  end

  def searchmember
    @thiscard = Card.find(params[:card_id].to_i)
    @current_member = @thiscard.users
  end

  def addmember
    new_member = User.find(params[:user_id].to_i)
    card = Card.find(params[:card_id])
    if card.users.include? new_member
      flash[:danger] = "User has been enrolled!"
    else
      card.users << new_member
      card.save
      n = Notification.new(recipient_id: new_member.id, card_id: card.id, read: false, source: "card")
      n.save
      CardMailer.add_user(new_member, n).deliver
    end
    ActionCable.server.broadcast "team_#{card.list.board.id}_channel",
                                 event: "add_member_to_card",
                                 card_id: card.id,
                                 user_id: new_member.id,
                                 user_name: new_member.name
    respond_to do |format|
      format.json { render json: {status: "success",member_id: new_member.id}}
    end

  end

  def deletemember
    CardEnrollment.delete(CardEnrollment.where(card_id:params[:card_id],user_id:params[:todeleteuser_id].to_i))
    card = Card.find(params[:card_id])
    user = User.find(params[:todeleteuser_id])
    ActionCable.server.broadcast "team_#{card.list.board.id}_channel",
                                 event: "delete_member_from_card",
                                 card_id: card.id,
                                 user_id: user.id,
                                 user_name: user.name
    respond_to do |format|
      format.json { render json: {status: "success",member_id: params[:todeleteuser_id]}}
    end
  end

  def edit_description
    card = Card.find(params[:card_id])
    card.description = params[:description]
    respond_to do |format|
      if card.save
        ActionCable.server.broadcast "team_#{card.list.board.id}_channel",
                                     event: "edit_card_description",
                                     card_id: card.id,
                                     description: card.description
        format.json { render json: {status: "success"}}
      else
        format.json { render json: {status: "failed"}}
      end
    end
  end


  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    name = params[:search].downcase
    @cards = Card.search_cards name
    respond_to do |format|
      format.html { render(:index) }
      format.js
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:list_id, :content, :deadline)
    end
end
