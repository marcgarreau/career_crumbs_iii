class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  STATE        = SecureRandom.hex(15)
  REDIRECT_URI = 'http://localhost:3000/users/auth/linkedin/callback'

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])

    client = LinkedIn::Client.new(ENV["LI_KEY"], ENV["LI_SECRET"])
    binding.pry

    request_token = client.request_token({}, :scope => "r_fullprofile r_emailaddress r_network")
    rtoken = request_token.token
    rsecret = request_token.secret
    redirect_to request_token.authorize_url

    binding.pry
    client.authorize_from_request(rtoken, rsecret, pin)
    # response =  HTTParty.get("http://api.linkedin.com/v1/people/~/suggestions/job-suggestions")
#    client = OAuth2::Client.new(
#      ENV["LI_KEY"],
#      ENV["LI_SECRET"],
#      :authorize_url => "/uas/oauth2/authorization?response_type=code",
#      :token_url     => "/uas/oauth2/accessToken",
#      :site          => "https://www.linkedin.com"
#    )
#    u_token = request.env["omniauth.auth"]["credentials"].token
#
#    redirect_to client.auth_code.authorize_url(
#      :scope => 'r_fullprofile r_emailaddress r_network'
#    )
#  end
#
#  def my_profile
#    binding.pry
#    token = client.auth_code.get_token(
#      # url.code,
#      :state        => STATE,
#      :redirect_uri => REDIRECT_URI
#    )
#    access_token = OAuth2::AccessToken.new(client, u_token, {
#      :mode   => :header,
#      :header => 'Bearer %s'
#    })
#
#    response = access_token.get("http://api.linkedin.com/v1/people/~/suggestions/job-suggestions")

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
