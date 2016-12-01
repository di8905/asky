class AttachmentsController < ApplicationController
  respond_to :js
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    respond_with @attachment.destroy if current_user.try(:author_of?, @attachable)
  end
end
