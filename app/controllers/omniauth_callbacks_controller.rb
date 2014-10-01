class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  STATE           = SecureRandom.hex(15)
  REDIRECT_URI    = 'http://localhost:3000/users/auth/linkedin/callback'
  REDIRECT_URI_II = 'http://localhost:3000/my_profile'

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    client = OAuth2::Client.new(
      ENV["LI_KEY"],
      ENV["LI_SECRET"],
      :authorize_url => "/uas/oauth2/authorization?response_type=code",
      :token_url     => "/uas/oauth2/accessToken",
      :site          => "https://www.linkedin.com"
    )
    code = params[:code]
    binding.pry
    token = client.auth_code.get_token(
      code,
      :state        => STATE,
      :redirect_uri => REDIRECT_URI
    )
    binding.pry
#    token = client.auth_code.get_token = (params[:code], :redirect_uri => 'http://localhost:3000/users/auth/linkedin/callback')
    access_token = OAuth2::AccessToken.new(client, token.token, {
      :mode => :header,
      :header_format => 'Bearer %s'
    })

    response = access_token.get("http://api.linkedin.com/v1/people/~/suggestions/job-suggestions")

#  end

#  def my_profile

    binding.pry
    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      flash.notice = "Something went wrong"
      redirect_to new_user_session_path
    end
  end


  alias_method :linkedin, :all
end
