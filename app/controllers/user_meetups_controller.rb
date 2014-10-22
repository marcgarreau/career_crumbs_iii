class UserMeetupsController < ApplicationController
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
    location  = user.location.gsub(" ", "")
    meetups   = []

    top_job_words.each do |word, _|
      response = HTTParty.get("https://api.meetup.com/find/groups?&key=781a42265a47f52554b1b4a50d5b43&sign=true&photo-host=public&text=#{word.value}&location=#{location}&page=1")
      meetups << [response.first, word.value]
    end

    meetups.each do |meetup, word|
      user.meetups.build(
        name:     meetup["name"],
        city:     meetup["city"],
        url:      meetup["link"],
        word:     word,
        user_id:  user.id
      )
    end
    user.save
  end
end
