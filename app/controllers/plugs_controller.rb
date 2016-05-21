class PlugsController < ApplicationController
    
    def new
        @plug = @current_user.plugs.new
    end
    
    def create
        @plug = @current_user.plugs.new(plug_params)
        @plug.state = "off"
        
        
        @plug.save
        
        
        
        redirect_to @current_user
    end
    
    private
        def plug_params
            params.require(:plug).permit(:name, :user_id)    
        end
end
