class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    common_callback('Facebook')    
  end
  
  def twitter
    common_callback('Twitter')
  end
  
  private
  def common_callback(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end
end
