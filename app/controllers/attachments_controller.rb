class AttachmentsController < ApplicationController
  respond_to :js
  authorize_resource
  
  
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    respond_with @attachment.destroy
  end
end
