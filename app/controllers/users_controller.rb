class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
    end
    
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params);
        if @user.save
            # redirect_to uses RESTful routing. When provided a specific object
            # it goes to that object's 'show' action
            
            # puts user_url(@user)
            # the user_url with argument @user builds out the url to that resource
            # https://home-connect-mstephenhunt.c9users.io/users/5
            redirect_to @user
        else
            render 'new'
        end
    end
    
    private
    
        def user_params
           params.require(:user).permit(:name, :email, :password, :password_confirmation) 
        end
    
end
