require 'rails_helper'

RSpec.describe "User", :type => :feature do
  let(:user) { User.create(first_name: "Joe",
                       last_name: "Shmoe",
                       email: "j@example.com",
                       location: "Greater Denver Area"
                      )}

  it "can view bookmarks in their dashboard" do
    visit dashboard_path
    expect(page).to have_content("Bookmarks")
  end

end
