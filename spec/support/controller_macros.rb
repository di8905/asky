module ControllerMacros 
  def sign_in_user
    before do
      @user = FactoryGirl.create(:user)
      @request.env['devide.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
