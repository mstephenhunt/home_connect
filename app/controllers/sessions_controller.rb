class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    if logged_in?
      redirect_to current_user
    end
  end
  
  def create
    @user = User.new
    @user.find_and_auth_user params[:session][:email].downcase, params[:session][:password]
    
    if !@user.errors.any?
      log_in @user
      redirect_to current_user
    else
      render 'new'
    end
  end
  
  
  def destroy
    log_out
    redirect_to root_url
  end
end
