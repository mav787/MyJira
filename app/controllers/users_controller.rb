class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        UserMailer.registration_confirmation(@user).deliver
        format.html { redirect_to root_url, notice: 'Please confirm your email address to continue' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def search

    likesyntax = 'name LIKE ?'
    if Rails.env.production?
       likesyntax = 'name ILIKE ?'
    end
    @users = User.where(likesyntax, "%#{params[:user_name]}%")
    @board = Board.find(params[:board_id]);
    respond_to do |format|
      format.js{}
    end
  end

  def search_for_assign
    likesyntax = 'name LIKE ?'
    if Rails.env.production?
       likesyntax = 'name ILIKE ?'
    end
    @users = User.where(likesyntax, "%#{params[:user_name]}%")
    @thiscard = Card.find(params[:card_id]);

    respond_to do |format|
      # format.html{}
      format.js{}
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to MyJira! Your email has been confirmed.
      Please sign in to continue."
      redirect_to login_url
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
