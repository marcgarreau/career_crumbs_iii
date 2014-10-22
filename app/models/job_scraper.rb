class JobScraper
  def self.scrape_jobs(user)
    agent = build_mechanize_agent
    job_words = user.jobs[0..9].map do |job|
      page = agent.get('https://www.linkedin.com/jobs2/view/' + job.linkedin_id.to_s)
      page.search(".skills-section").text
    end
    job_words
  end

  def self.build_mechanize_agent
    Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
  end
end
