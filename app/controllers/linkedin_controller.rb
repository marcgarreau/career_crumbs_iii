class LinkedinController < ApplicationController
  def init_client
    client = LinkedIn::Client.new(ENV["LI_KEY"], ENV["LI_SECRET"])
    request_token = client.request_token({}, :scope => "r_fullprofile+r_emailaddress+r_network")
    rtoken = request_token.token
    rsecret = request_token.secret
    request_token.authorize_url
    client.authorize_from_request(rtoken, rsecret, pin)
    # client.authorize_from_access( # , # )
  end
end
