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
    educations       = body["educations"].values[1]
    positions        = body["positions"].values[1]
    industry         = body["industry"]
    last_name        = body["lastName"]
    first_name       = body["firstName"]
    location         = body["location"]["name"]
    picture_url      = body["pictureUrl"]
    headline         = body["headline"]
    email_address    = body["emailAddress"]

    @user = User.find_by_email(email_address) || User.create(
      email:      email_address,
      first_name: first_name,
      last_name:  last_name,
      location:   location,
      headline:   headline,
      industry:   industry,
      pic_url:    picture_url
    )

    jobs_response = access_token.get("https://api.linkedin.com/v1/people/~/suggestions/job-suggestions:(jobs:(position:(title),company:(name),id,description-snippet,location-description))?format=json")
    jobs          = JSON(jobs_response.body)["jobs"].values[1][0..14]
    jobs.each do |job|
      @user.jobs.create(
        title:       job["position"]["title"],
        company:     job["company"]["name"],
        description: job["descriptionSnippet"],
        location:    job["locationDescription"],
        linkedin_id: job["id"]
      )
    end

    a = Mechanize.new { |agent|
     agent.user_agent_alias = 'Mac Safari'
    }

    job_words = []
    @user.jobs[0..14].each do |job|
      page = a.get('https://www.linkedin.com/jobs2/view/' + job.linkedin_id.to_s)
      job_words << page.search(".skills-section").text
    end
    format_job_words = job_words.join(" ").downcase.gsub(/[^\w\s]/, "").split(" ")
    grouped_job_words = format_job_words.group_by {|word| word}.sort_by { |words, occurrences| occurrences.count }.reverse
    top_fifteen_words = grouped_job_words[0..24].map { |word, occurrences| [word, occurrences.count] }

    omitted_words = ["and", "or", "the", "of", "in", "a", "such",
       "to", "●", "•", "skills", "experience", "with", "knowledge",
       "strong", "work", "must", "required", "desired", "ability",
       "years", "have", "related", "for", "preferred", "is", "an",
       "on", "as", "\t", "\n", " ", "other", "1", "2", "3", "using",
       "including", "good", "content", "environment", "qualifications",
       "plus", "organizational", "multiple", "minimum", "deadlines",
       "be", "working", "familiarity", "degree", "team", "demonstrated",
       "one", "all", "building", "at", "andor", "you", "are", "up",
       "that", "if", "able", "more", "year", "your"]

    top_filtered_words = []
    top_fifteen_words.each do |word, occurrences|
      top_filtered_words << [word, occurrences] unless omitted_words.include?(word)
    end
#    session["top_words"] = top_filtered_words
    top_filtered_words.each do |word, occurrences|
      @user.words.create(
        value: word,
        occurrences: occurrences
      )
    end


    if @user.persisted?
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
