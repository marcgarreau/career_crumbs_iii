module FeatureSpecHelper
  def mock_auth
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
      :provider => 'linkedin',
      :uid => '123545'
    #  :redirect_uri => 'http://localhost:3000/profile'
    })
  end

#  def sign_in
    # visit root_path
    # expect page to be right
    # auth_mock
    # click log in
#  end
end
