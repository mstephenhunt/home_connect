class ModalsController < ApplicationController
    def show
        # The specific modal that'll be rendered with it's local vars
        @modal_partial = params[:modal]
        @header_glyphicon = params[:header_glyphicon]
        @header_title = params[:header_title]
        @modal_id = params[:modal_id]
        
        # The specific form that'll render in this modal
        @form_partial = params[:form_partial]
        @object = params[:object_type].constantize.find(params[:object_id])
        
        # If this is edit_plugs, get specific data for the modal
        if @form_partial == "plugs/edit_plug"
            edit_plug_data
        end
        
        respond_to do |format|
            format.js { render :action => :show }
        end
    end
    
        # The edit modal needs the list of rooms and the
        # current room's name
        def edit_plug_data
            @form_data = Hash.new
            @form_data[:rooms] = Array.new
            
            current_user.rooms.each do |r|
                @form_data[:rooms].push r
                
                if r.id == @object.room_id
                    @form_data[:current_room_name] = r.name
                end
            end
        end
end
