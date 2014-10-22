class WordsWorker
  include Sidekiq::Worker

  def perform(user_id)
    user               = User.find_by_id(user_id)
    job_words          = JobScraper.scrape_jobs(user)
    top_filtered_words = WordFormatter.format_api_results(job_words)
    build_words(top_filtered_words, user)
  end

  def build_words(top_filtered_words, user)
    top_filtered_words.each do |word, occurrences|
      user.words.build(
        value:       word,
        occurrences: occurrences
      )
    end
    user.save
  end
end
