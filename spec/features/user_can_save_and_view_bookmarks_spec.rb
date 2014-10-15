require 'rails_helper'

RSpec.describe "User", :type => :feature do

  let(:user) { User.create(
                       first_name:    "Joe",
                       last_name:     "Shmoe",
                       email:         "j@example.com",
                       location:      "Greater Denver Area"
  )}

  let(:job) { user.jobs.create(
                        title: "Scuba Pirate",
                        company: "Underwater Pirate Club, Inc.",
                        description: "Shiver me timbers",
                        linkedin_id: 24871,
                        location: "Denver Area"
  )}

  let(:word) { user.words.create(
                        value: "scuba",
                        occurrences: 6
  )}

  let(:meetup) { user.meetups.create(
                        name: "Denver Scuba Pirate Club",
                        url:  "http://www.meetup.com",
                        city: "Denver",
                        word: "scuba"
  )}

  before(:each) do
    job
    word
    meetup
    stub_current_user
  end

  it "can view the empty bookmarks display in their dashboard" do
    visit dashboard_path
    expect(page).to have_content "Joe"
    expect(page).to have_css ".getting-started-title"
    expect(page).to have_css ".empty-bookmarks"
  end

  it "can navigate to the suggestions page" do
    visit dashboard_path
    click_link_or_button "View Suggestions"
    expect(page).to have_css ".suggested-job-head"
    expect(page).to have_css ".job-words-head"
  end

  it "can make a job bookmark and view it in the dashboard" do
    visit suggestions_path
    expect(page).to have_content "1 positions"
    first(".btn-bookmark").click
    expect(page).to have_content "Bookmarked"
    visit dashboard_path
    expect(page).to have_css ".bookmark-subtitle"
    expect(page).to have_content "Scuba Pirate"
  end

  it "can make, then remove a job bookmark" do
    visit suggestions_path
    expect(page).not_to have_content "Bookmarked"
    first(".btn-bookmark").click
    expect(page).to have_content "Bookmarked"
    first(".btn-unbookmark").click
    expect(page).not_to have_content "Bookmarked"
  end
end
