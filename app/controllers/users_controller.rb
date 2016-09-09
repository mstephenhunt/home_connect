class UsersController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]

    def show
        # Prevent the user from routing to anywhere but their user
        @user = User.find(@current_user.id)
        @plugs = @user.plugs
        @rooms = @user.rooms.order(created_at: :asc)
    end
    
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params);
        if @user.save
            # redirect_to uses RESTful routing. When provided a specific object
            # it goes to that object's 'show' action
            
            # log in the user
            log_in(@user)
            
            # the user_url with argument @user builds out the url to that resource
            # https://home-connect-mstephenhunt.c9users.io/users/5
            redirect_to user_url(@user)
        else
            render 'new'
        end
    end
    
    private
    
        def user_params
           params.require(:user).permit(:name, :email, :password, :password_confirmation) 
        end
    
end
