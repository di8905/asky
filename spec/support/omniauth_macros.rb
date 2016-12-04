module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = OmniAuth::AuthHash.new(
    {
      'provider' => provider,
      'uid' => '12345',
      'info' => {
        'email' => 'user@example.com'
      },
      'user_info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url',
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end
