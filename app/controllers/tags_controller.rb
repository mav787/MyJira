class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        CardTagAssociation.create(card_id: params['card_id'], tag_id: @tag.id)
        ActionCable.server.broadcast "team_#{@tag.board_id}_channel",
                                     event: "create_tag",
                                     card_id: params['card_id'],
                                     tag_id: @tag.id,
                                     tag_name: @tag.name,
                                     tag_color: @tag.color
        format.json { render :show, status: :created, location: @tag }
      else
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def bind
    tag = Tag.find(params['tag_id'].to_i)
    CardTagAssociation.create(card_id: params['card_id'], tag_id: params['tag_id'])
    ActionCable.server.broadcast "team_#{tag.board_id}_channel",
                                 event: "bind_tag",
                                 card_id: params['card_id'],
                                 tag_id: params['tag_id'],
                                 tag_name: tag.name,
                                 tag_color: tag.color
    respond_to do |format|
      format.json { render json: {status: 'success', tag_id: params['tag_id']} }
    end
  end

  def unbind
    card_tag = CardTagAssociation.where(card_id: params['card_id'], tag_id: params['tag_id'])[0]
    if card_tag != nil
      card_tag.destroy
      card_tag.save
    end
    tag = Tag.find(params['tag_id'].to_i)
    ActionCable.server.broadcast "team_#{tag.board_id}_channel",
                                 event: "unbind_tag",
                                 card_id: params['card_id'],
                                 tag_id: params['tag_id'],
                                 tag_name: tag.name,
                                 tag_color: tag.color
    respond_to do |format|
      format.json { render json: {status: 'success', tag_id: params['tag_id']} }
    end
  end
  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.permit(:name, :color, :board_id)
    end
end
