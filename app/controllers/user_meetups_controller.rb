class UserMeetupsController < ApplicationController
  before_filter :authenticate_user!

  layout nil

  def show
    @meetups_to_show = find_or_build_meetups(current_user, current_user.words)
    @user = current_user
    render :layout => false
  end

  private

  def find_or_build_meetups(user, top_job_words)
    if user.meetups.empty?
      build_meetups(user, top_job_words)
    end
    user.meetups
  end

  def build_meetups(user, top_job_words)
    meetups = top_job_words.map do |word, _|
      response = HTTParty.get("https://api.meetup.com/find/groups", query: {
        :key => ENV["MEETUP_KEY"],
        :sign => true,
        :"photo-host" => "public",
        :text => word.value,
        :location => user.location,
        :page => 1,
      })

      meetup = response.first
      {
        name:     meetup["name"],
        city:     meetup["city"],
        url:      meetup["link"],
        word:     word.value,
      }
    end

    user.meetups.create(meetups)
    user.meetups
  end
end
