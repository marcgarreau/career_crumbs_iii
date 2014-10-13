class DashboardsController < ApplicationController

  def show
    @user          = current_user
    bookmarks = @user.bookmarks.where(bookmarkable_type: "Job")
    @job_bookmarks = bookmarks.map { |bm| @user.jobs.find_by_id(bm.bookmarkable_id) }
  end

end
