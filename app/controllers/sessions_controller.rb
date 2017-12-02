class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        log_in user
        redirect_to user
      else
        flash.now[:error] = 'Please activate your account by following the
        instructions in the account confirmation email you received to proceed'
        render 'new'
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def google_create
    user = User.from_omniauth(request.env["omniauth.auth"])
    log_in user
    redirect_to user
  end

  def destroy
    log_out
    #redirect_to root_url
    redirect_to root_path
  end
end
