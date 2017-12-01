class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy, :stats]

  # GET /boards
  # GET /boards.json
  def index
    if logged_in?
      @boards = current_user.boards
    else
      @boards = []
    end
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    notes = current_user.notifications.where(board_id: @board.id)
    if (notes != nil)
      notes.each do |note|
        note.update(read: true)
      end
    end
  end

  def enroll
    enrolled = User.find(params[:user].to_i)
    Board.find(params[:board]).users << enrolled
    n = Notification.new(recipient_id: enrolled.id, board_id: params[:board].to_i, read: false, source: "board")
    n.save
    BoardMailer.enroll_note(enrolled, n).deliver
    redirect_to board_path(id:params[:board])
  end

  # GET /boards/new
  def new
    @board = Board.new
  end

  # GET /boards/1/edit
  def edit
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(board_params)
    respond_to do |format|
      if @board.save
        @board.users << current_user
        List.create(name: "todo",board_id: @board.id.to_i)
        List.create(name: "doing",board_id: @board.id.to_i)
        List.create(name: "done",board_id: @board.id.to_i)
        format.html { redirect_to @board, notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1
  # PATCH/PUT /boards/1.json
  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board.destroy
    respond_to do |format|
      format.html { redirect_to boards_url, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def stats
    @users = @board.users
    @cards = Card.joins("inner join lists on cards.list_id = lists.id").where(lists: {board_id: @board.id})
    @user_cards = @cards.joins("join card_enrollments on card_enrollments.card_id = cards.id join users on card_enrollments.user_id = users.id")
    @ind_user_cards = Hash.new
    @users.each do |u|
      @ind_user_cards[u.id] = @user_cards.where(users: {id: u.id})
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_params
      params.require(:board).permit(:name, :description, :leader_id)
    end


end
