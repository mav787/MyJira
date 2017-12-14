class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @card = Card.find(params[:card_id])
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @card = Card.find(params[:comment][:card_id])
    @comment.from_user_id = current_user.id
    to_user_name = ""
    respond_to do |format|
      if @comment.save
        if(@comment.to_user_id != nil)
          n = Notification.new(recipient_id: comment_params[:to_user_id], comment_id: @comment.id, card_id: @card.id, read: false, source: "comment")
          n.save
          ActionCable.server.broadcast "#{comment_params[:to_user_id]}_channel", event: "note_created"
          CommentMailer.comment_note(n.recipient, n).deliver
          to_user_name = User.find(@comment.to_user_id).name
        end
        ActionCable.server.broadcast "team_#{@card.list.board.id}_channel",
                                     event: "create_comment",
                                     card_id: @card.id,
                                     context: @comment.context,
                                     from_user_id: @comment.from_user_id,
                                     from_user_name: User.find(@comment.from_user_id).name,
                                     to_user_id: @comment.to_user_id,
                                     to_user_name: to_user_name,
                                     created_at: @comment.created_at
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:context, :from_user_id, :card_id, :to_user_id)
    end
end
