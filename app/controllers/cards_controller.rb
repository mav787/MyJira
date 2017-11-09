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
    notes = current_user.notifications.where(card_id: @card.id)
    if (notes != nil)
      notes.each do |note|
        note.update(read: true)
      end
    end
  end

  # GET /cards/new
  def new
    @card = Card.new
    @list = List.find(params[:list_id])
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    pars = params[:card]
    @tags = pars[:tagst].split(',')
    @card = Card.new(card_params)
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
    moving_card.card_order = params[:new_position]
    moving_card.list_id = params[:new_list_id]
    moving_card.save
    new_list_cards = Card.where("list_id = ? AND card_order >= ?", moving_card.list_id, moving_card.card_order).where.not(id:moving_card.id)
    new_list_cards.each do |card|
      card.card_order += 1
      card.save
    end
    respond_to do |format|
      format.js{}
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
