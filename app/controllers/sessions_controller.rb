class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    # show login screen if you're not logged in
    # otherwise, route the user to user#show
    if logged_in?
      redirect_to user_url(current_user)
    end
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      # Log in and redirect
      log_in(user)
      redirect_to user
    else
      # Error, re-render new
      redirect_to root_url
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
