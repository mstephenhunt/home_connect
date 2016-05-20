module SessionsHelper

    # Takes in a user, sets user as logged in under session
    def log_in(user)
        session[:user_id] = user.id 
    end

    # Returns the logged in user
    def current_user
        # The ||= is explained in here: https://www.railstutorial.org/book/log_in_log_out
        @current_user ||= User.find_by(id: session[:user_id])
    end
    
    def log_out
        @current_user = nil
        session[:user_id] = nil
    end
    
    def logged_in?
        !current_user.nil?
    end
end
