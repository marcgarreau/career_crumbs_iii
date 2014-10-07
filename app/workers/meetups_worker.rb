class MeetupWorker
  include Sidekiq::Worker

  def perform(user_id, top_job_words)
    user = User.find(id: user_id)
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
