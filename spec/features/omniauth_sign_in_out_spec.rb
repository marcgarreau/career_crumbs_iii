require 'rails_helper'

RSpec.describe "LinkedIn log in", :type => :feature do

#  before do
#    request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
#    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
#  end

  describe "a user with credentials" do
    it "logs in successfully" do
      visit root_path
      mock_auth
      click_link_or_button "Log in"
      # stub out the next linkedin api call for jobs
      # then a background job goes off to scrap the jobs and return some words
      expect(page).to have_content "Welcome"
    end
  end

  describe "a user without credentials" do
    it "does not log in successfully" do
      visit root_path
      # mock_auth with bad credentials
      OmniAuth.config.mock_auth[:linkedin] = :invalid_credentials
      click_link_or_button "Log in"
      expect(request.code).to eq 401
      # get rejected
    end
  end
end
