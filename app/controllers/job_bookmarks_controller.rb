class JobBookmarksController < ApplicationController
  def create
    user = current_user
    user.bookmarks.build(
      bookmarkable_id:   params[:id],
      bookmarkable_type: "job"
    )
    if user.save
      flash[:success] = "Job bookmarked!"
      redirect_to i_path
    else
      flash[:error] = "Something went wrong"
      redirect_to i_path
    end
  end

  def destroy
    user = current_user
    bm = user.bookmarks
    if bm.delete
      flash[:notice] = "Bookmark removed"
      redirect_to i_path
    else
      flash[:error] = "Something went wrong."
      redirect_to i_path
    end
  end
end
