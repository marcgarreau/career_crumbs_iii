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
    access_token = build_access_token(params[:code], params[:state])
    get_user_from_linkedin(access_token)
    find_or_build_user(access_token)

    if @user.persisted?
      flash.notice = "Welcome, #{@user.first_name}! You're logged in."
      sign_in_and_redirect @user
    else
      session["devise.user_attributes"] = @user.attributes
      flash.notice = "Something went wrong. Please try again."
      redirect_to new_user_session_path
    end
  end

  def build_access_token(code, state)
    if state != STATE
      raise "state has changed. that's fishy."
    else
      token ||= client.auth_code.get_token(code, :redirect_uri => REDIRECT_URI)
      access_token ||= OAuth2::AccessToken.new(client, token.token, {
        :mode => :header,
        :header_format => 'Bearer %s'
      })
    end
    access_token
  end

  def find_or_build_user(access_token)
    if User.find_by_email(@email_address)
      @user = User.find_by_email(@email_address)
    else
      @user = build_user
      build_jobs(access_token)
      scrape_jobs_and_build_words
    end
  end

  def get_user_from_linkedin(access_token)
    profile_response = access_token.get("https://api.linkedin.com/v1/people/~:(first-name,last-name,industry,positions,educations,picture-url,headline,location,email-address)?format=json")
    body             = JSON(profile_response.body)
    @educations       = body["educations"].values[1]
    @positions        = body["positions"].values[1]
    @industry         = body["industry"]
    @last_name        = body["lastName"]
    @first_name       = body["firstName"]
    @location         = body["location"]["name"]
    @picture_url      = body["pictureUrl"]
    @headline         = body["headline"]
    @email_address    = body["emailAddress"]
  end

  def build_user
    @user = User.create(
      email:      @email_address,
      first_name: @first_name,
      last_name:  @last_name,
      location:   @location,
      headline:   @headline,
      industry:   @industry,
      pic_url:    @picture_url
    )
  end

  def build_jobs(access_token)
    jobs_response = access_token.get("https://api.linkedin.com/v1/people/~/suggestions/job-suggestions:(jobs:(position:(title),company:(name),id,description-snippet,location-description))?format=json")
    jobs          = JSON(jobs_response.body)["jobs"].values[1][0..9]
    jobs.each do |job|
      @user.jobs.build(
        title:       job["position"]["title"],
        company:     job["company"]["name"],
        description: job["descriptionSnippet"],
        location:    job["locationDescription"],
        linkedin_id: job["id"]
      )
    end
    @user.save
  end

  def scrape_jobs_and_build_words
    WordsWorker.perform_async(@user.id)
  end

  alias_method :linkedin, :all
end
