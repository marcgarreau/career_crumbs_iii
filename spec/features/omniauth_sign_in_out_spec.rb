require 'rails_helper'

RSpec.describe "LinkedIn log in", :type => :feature, :js => true do

  # Dear onlooker, testing this application has not gone well. Send help.

  describe "a user with credentials" do
   xit "logs in successfully" do
      visit 'http://lvh.me:1234'
      mock_auth
      click_link_or_button "Log in"
      # stub out the second linkedin api call for jobs
      # then a background job goes off to scrape the jobs and return some keywords
      expect(page).to have_content "Welcome"
    end
  end

  describe "a user without credentials" do
    xit "does not log in successfully" do
      visit root_path
      # mock_auth with bad credentials
      # OmniAuth.config.mock_auth[:linkedin] = :invalid_credentials
      # click_link_or_button "Log in"
      # expect(request.code).to eq 401
      # get(page).to have_content "Log in"
    end
  end
end
