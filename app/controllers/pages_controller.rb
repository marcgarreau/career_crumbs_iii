class PagesController < ApplicationController
  def welcome
  end

  def i
    @user          = current_user
    @top_job_words = find_top_job_words_for(@user)
  end

  private

  def find_top_job_words_for(user)
    a = Mechanize.new { |agent|
     agent.user_agent_alias = 'Mac Safari'
    }

    job_words = []
    @user.jobs[0..9].each do |job|
      page = a.get('https://www.linkedin.com/jobs2/view/' + job.linkedin_id.to_s)
      job_words << page.search(".skills-section").text
    end
    format_job_words = job_words.join(" ").downcase.delete(",./\t\n-").split(" ")
    grouped_job_words = format_job_words.group_by {|word| word}.sort_by { |words, occurences| occurences.count }.reverse
    top_fifteen_words = grouped_job_words[0..49].map { |word, occurences| [word, occurences.count] }

    omitted_words = ["and", "or", "the", "of", "in", "a", "such",
       "to", "●", "•", "skills", "experience", "with", "knowledge",
       "strong", "work", "must", "required", "desired", "ability",
       "years", "have", "related", "for", "preferred", "is", "an",
       "on", "as", "\t", "\n", " ", "other", "1", "using", "year",
       "including", "good"]
    top_filtered_words = []
    top_fifteen_words.each do |word, occurences|
      top_filtered_words << [word, occurences] unless omitted_words.include?(word)
    end
    top_filtered_words
  end
end
