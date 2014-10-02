class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  STATE            = SecureRandom.hex(15)
  REDIRECT_URI_II  = 'http://localhost:3000/users/auth/linkedin/callback'
  REDIRECT_URI     = 'http://localhost:3000/accept'

  def client
    client = OAuth2::Client.new(
      ENV["LI_KEY"],
      ENV["LI_SECRET"],
      :authorize_url => "/uas/oauth2/authorization?response_type=code",
      :token_url     => "/uas/oauth2/accessToken",
      :site          => "https://www.linkedin.com",
      :ssl           => { :verify => OpenSSL::SSL::VERIFY_NONE }
    )
  end

  def all
    @user = User.from_omniauth(request.env["omniauth.auth"])
    authorize
  end

  def index
    authorize
  end

  def authorize
    redirect_to client.auth_code.authorize_url(
      :scope => "r_fullprofile rw_nus r_emailaddress r_network",
      :state => STATE,
      :redirect_uri => REDIRECT_URI
    )
  end

  def accept
    code  = params[:code]
    state = params[:state]
    if state != STATE
      raise "state has changed. that's fishy."
    else
      token = client.auth_code.get_token(code, :redirect_uri => REDIRECT_URI)
      access_token = OAuth2::AccessToken.new(client, token.token, {
        :mode => :header,
        :header_format => 'Bearer %s',
        :ssl => {:verify => false}
      })
      binding.pry
    end
    response = access_token.get("http://api.linkedin.com/v1/people/~/suggestions/job-suggestions")
#    if user.persisted?
#      flash.notice = "Signed in!"
#      sign_in_and_redirect user
#    else
#      session["devise.user_attributes"] = user.attributes
#      flash.notice = "Something went wrong"
#      redirect_to new_user_session_path
#    end
  end


  alias_method :linkedin, :all
end
