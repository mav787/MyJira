class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    if logged_in?
      @cards = []
      current_user.boards.each do |board|
        board.lists.each do |list|
          list.cards.each do |card|
            @cards.push(card)
          end
        end
      end
    else
      @cards = []
    end

    # @cards = Card.all
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
    respond_to do |format|
      format.json { render json: @card}
    end
  end

  # GET /cards/new
  def new
    @card = Card.new
    @list = List.find(params[:list_id])
  end

  # GET /cards/1/edit
  def edit
    @list = @card.list
  end

  # POST /cards
  # POST /cards.json
  def create
=begin
@card = Card.new(card_params)
@card.card_order = Card.where(list_id:params[:card][:list_id]).count+1
@list = List.find(params[:card][:list_id])
@board = Board.find(@list.board.id)
=end
    pars = params[:card]
    @tags = pars[:tagst].split(',')
    @card = Card.new(card_params)
    @card.card_order = Card.where(list_id:params[:card][:list_id]).count+1
    @board = Board.find(List.find(pars[:list_id]).board.id)
    respond_to do |format|
      if @card.save
        @tags.each do |tag_name|
          tag = Tag.find_by_name(tag_name)
          if (tag == nil)
            tag = Tag.new(name: tag_name, color: 'default')
            tag.save
          end
          CardTagAssociation.create(card_id: @card.id, tag_id: tag.id)
        end
        format.html { redirect_to @board, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    moving_card = Card.find(params[:card_id])
    origin_list_cards = Card.where("list_id = ? AND card_order > ?", moving_card.list_id, moving_card.card_order)
    origin_list_cards.each do |card|
      card.card_order -= 1
      card.save
    end
    old_list = moving_card.list
    new_list = List.find(params[:new_list_id])
    if new_list.name == 'done'
      moving_card.finished_at = Time.now
    elsif old_list.name == 'done'
      moving_card.finished_at = nil
    end
    moving_card.card_order = params[:new_position]
    moving_card.list_id = params[:new_list_id]
    if moving_card.list_id == 2
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
                                 card_id: moving_card.id,
                                 list_id: moving_card.list.id,
                                 order: moving_card.card_order
    respond_to do |format|
      format.js{}
    end
  end

  def searchmember
    @thiscard = Card.find(params[:card_id].to_i)
  end

  def addmember
    new_member = User.find(params[:user_id].to_i)
    card = Card.find(params[:card_id])
    if card.users.include? new_member
      flash[:alert] = "User has been enrolled!"
    else
      card.users << new_member
    end
    redirect_to root_path#board_path(id:params[:board])
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
