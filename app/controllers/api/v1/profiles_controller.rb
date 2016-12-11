class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User
  
  respond_to :json
  
  def me
    current_user = current_resource_owner
    respond_with current_resource_owner
  end
  
  def index
    respond_with User.where.not(id: current_resource_owner.id)
  end
end
