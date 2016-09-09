class PlugsController < ApplicationController
    
    def new
        @plug = @current_user.plugs.new
    end
    
    def create
        @plug = @current_user.plugs.new(plug_params)
        if @plug.save
            redirect_to @current_user
        else
            render 'new'
        end
    end
    
    def edit
        @plug = Plug.find(params[:id])
    end
    
    def update
        @plug = Plug.find(params[:id])
        if @plug.update_attributes(plug_params)
            redirect_to current_user
        else
            render 'edit'
        end
    end
    
    def destroy
        Plug.find(params[:id]).destroy
        redirect_to current_user
    end
    
    def flip_plug
        plug = Plug.find(params[:format])
        plug.flip_plug
        redirect_to current_user
    end
    
    private
        def plug_params
            params.require(:plug).permit(:name, :user_id, :feed_id, :room_id)
        end
end
