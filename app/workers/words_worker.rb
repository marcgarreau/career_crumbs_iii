class WordsWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    a    = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    job_words = []
    user.jobs[0..9].each do |job|
      page = a.get('https://www.linkedin.com/jobs2/view/' + job.linkedin_id.to_s)
      job_words << page.search(".skills-section").text
    end
    format_job_words = job_words.join(" ").downcase.gsub(/[^\w\s]/, "").split(" ")
    grouped_job_words = format_job_words.group_by {|word| word}.sort_by { |words, occurrences| occurrences.count }.reverse
    top_fifteen_words = grouped_job_words[0..29].map { |word, occurrences| [word, occurrences.count] }

    omitted_words = ["and", "or", "the", "of", "in", "a", "such",
      "to", "●", "•", "skills", "experience", "with", "knowledge",
      "strong", "work", "must", "required", "desired", "ability",
      "years", "have", "related", "for", "preferred", "is", "an",
      "on", "as", "\t", "\n", " ", "other", "1", "2", "3", "4", "5",
      "including", "good", "content", "environment", "qualifications",
      "plus", "organizational", "multiple", "minimum", "deadlines",
      "be", "working", "familiarity", "degree", "team", "demonstrated",
      "one", "all", "building", "at", "andor", "you", "are", "up",
      "that", "if", "able", "more", "year", "your", "using", "o",
      "etc", "understanding", "should", "candidate", "from", "our",
      "will"]

    top_filtered_words = []
    top_fifteen_words.each do |word, occurrences|
      top_filtered_words << [word, occurrences] unless omitted_words.include?(word)
    end

    top_filtered_words.each do |word, occurrences|
      user.words.build(
        value: word,
        occurrences: occurrences
      )
    end
    user.save

  end
end
