class DashboardsController < ApplicationController

  def show
    @user             = current_user
    bookmarks         = @user.bookmarks.where(bookmarkable_type: "Job")
    @job_bookmarks    = bookmarks.map { |bm| @user.jobs.find_by_id(bm.bookmarkable_id) }
    m_bookmarks       = @user.bookmarks.where(bookmarkable_type: "Meetup")
    @meetup_bookmarks = m_bookmarks.map { |bm| @user.meetups.find_by_id(bm.bookmarkable_id) }
  end

end
