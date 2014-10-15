module FeatureSpecHelper
  def mock_auth
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
      :provider => 'linkedin',
      :uid => '123545'
    })
  end

  def stub_current_user
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end
end
