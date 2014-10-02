class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  STATE            = SecureRandom.hex(15)
  REDIRECT_URI_II  = 'http://localhost:3000/users/auth/linkedin/callback'
  REDIRECT_URI     = 'http://localhost:3000/profile'

  def client
    client = OAuth2::Client.new(
      ENV["LI_KEY"],
      ENV["LI_SECRET"],
      :authorize_url => "/uas/oauth2/authorization?response_type=code",
      :token_url     => "/uas/oauth2/accessToken",
      :site          => "https://www.linkedin.com"
    )
  end

  def all
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

  def profile
#    @user = User.from_omniauth(request.env["omniauth.auth"])
    code  = params[:code]
    state = params[:state]
    if state != STATE
      raise "state has changed. that's fishy."
    else
      token ||= client.auth_code.get_token(code, :redirect_uri => REDIRECT_URI)
      access_token ||= OAuth2::AccessToken.new(client, token.token, {
        :mode => :header,
        :header_format => 'Bearer %s'
      })
    end

    profile_response = access_token.get("https://api.linkedin.com/v1/people/~:(first-name,last-name,industry,positions,educations,picture-url,headline,location,email-address)?format=json")
    body             = JSON(profile_response.body)
#   educations   = body["educations"].values[1]
    positions        = body["positions"].values[1]
    industry         = body["industry"]
    last_name        = body["lastName"]
    first_name       = body["firstName"]
    location         = body["location"]
    picture_url      = body["pictureUrl"]
    headline         = body["headline"]
    email_address    = body["emailAddress"]

    @user = User.find_by_email(email_address) || User.create(
      email:      email_address,
      first_name: first_name,
      last_name:  last_name,
      headline:   headline,
      industry:   industry,
      pic_url:    picture_url
    )

    jobs_response = access_token.get("https://api.linkedin.com/v1/people/~/suggestions/job-suggestions?format=json")
    jobs          = JSON(jobs_response.body)["jobs"].values[1]
    jobs.each do |job|
      @user.jobs.create(
        title:   job.title,
        company: job.company
      )
    end

    if @user.persisted?
      binding.pry
      flash.notice = "Signed in!"
      sign_in_and_redirect @user
    else
      session["devise.user_attributes"] = @user.attributes
      flash.notice = "Something went wrong"
      redirect_to new_user_session_path
    end
  end

  alias_method :linkedin, :all
end
