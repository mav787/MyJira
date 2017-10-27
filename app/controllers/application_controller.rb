class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def hello
    if logged_in?
      redirect_to user_path(current_user.id)
    end

  end
end
