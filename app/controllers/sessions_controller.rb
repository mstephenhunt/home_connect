class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    if logged_in?
      redirect_to user_url(current_user)
    end
  end
  
  def create
    # Create bools used to determine if the user can log in
    # and @user to hold potential error messages
    user = nil; auth = nil;
    @user = User.new
    
    # Log in. If it's unable, will set error messages on @user
    log_in_and_auth(user, auth)
    
    if user && auth
      # Log in and redirect
      log_in(user)
      redirect_to user
    else
      # Error, re-render new
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
  ################################# Private ###########################
  
  private
    def log_in_and_auth(user, auth)
      # Attempt to find the user based on email provided
      user = User.find_by(email: params[:session][:email].downcase)
      
      # If you've found the user, next try to authenticate them
      if user
        auth = user.authenticate(params[:session][:password])
      end
      
      # Set any error messages
      if !user
        @user.errors.add :email, params[:session][:email].downcase + ' not found'
      elsif !auth && !auth.nil?
        @user.errors.add :password
      end
    end
end
