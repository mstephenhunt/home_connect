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
        
        respond_to do |format|
            format.js { render :action => :show }
        end
    end
end
