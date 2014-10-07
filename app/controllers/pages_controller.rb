class PagesController < ApplicationController
  def welcome
  end

  def i
    @user            = current_user
    @top_job_words   = current_user.words
    @meetups_to_show ||= find_top_meetups_for(@user, @top_job_words)
  end

  private

  def find_top_meetups_for(user, top_job_words)
    location = user.location.gsub(" ", "")
    meetups = []
    top_job_words.each do |word|
      if word.value.strip != ""
        response = HTTParty.get("https://api.meetup.com/find/groups?&key=781a42265a47f52554b1b4a50d5b43&sign=true&photo-host=public&text=#{word.value}&location=#{location}&page=1")
        meetups << [response.first, word.value]
      end
    end
    meetups
  end
end
