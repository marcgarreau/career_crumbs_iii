module FeatureSpecHelper
  def auth_mock
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
      :provider => 'linkedin',
      :uid => '123545'
    })
  end

  def sign_in
    # visit root_path
    # expect page to be right
    # auth_mock
    # click log in
  end
end
