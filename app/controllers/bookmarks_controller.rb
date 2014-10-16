class BookmarksController < ApplicationController

  def create
    @bookmark = current_user.bookmarks.build(
      user_id: params[:bookmark]["user_id"].to_i,
      bookmarkable_type: params[:bookmark]["bookmarkable_type"],
      bookmarkable_id: params[:bookmark]["bookmarkable_id"].to_i
    )
    if @bookmark.save
      flash[:notice] = "Bookmarked!"
      redirect_to suggestions_path
    else
      flash[:error] = "Something went wrong"
      redirect_to suggestions_path
    end
  end

  def destroy
    bm = current_user.bookmarks.find_by(
      bookmarkable_type: params[:bookmark]["bookmarkable_type"],
      bookmarkable_id:   params[:bookmark]["bookmarkable_id"]
    )
    if bm.delete
      flash[:notice] = "Bookmark removed"
      redirect_to suggestions_path
    else
      flash[:error] = "Something went wrong."
      redirect_to suggestions_path
    end
  end
end
