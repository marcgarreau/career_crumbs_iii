class WordFormatter
  def self.format_api_results(job_words)
    format_job_words = job_words.join(" ").downcase.gsub(/[^\w\s]/, "").split(" ")
    grouped_job_words = format_job_words.group_by {|word| word}.sort_by { |words, occurrences| occurrences.count }.reverse
    top_n_words = grouped_job_words[0..27].map { |word, occurrences| [word, occurrences.count] }

    top_filtered_words = top_n_words.map do |word, occurrences|
      [word, occurrences] unless omitted_words.include?(word)
    end
    top_filtered_words.compact
  end

  private

  def self.omitted_words
    ["and", "or", "the", "of", "in", "a", "such",
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
      "will", "candidates", "application", "we", "it", "also", "survey",
      "love", "research", "but", "can", "love", "field", "like"]
  end
end
