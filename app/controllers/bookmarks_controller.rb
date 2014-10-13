class BookmarksController < ApplicationController

  def index
    @bookmarkable = find_bookmarkable
    @bookmarkable.bookmarks
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    # @bookmarkable = find_bookmarkable
    @bookmark     = current_user.bookmarks.build(
      user_id: params[:bookmark]["user_id"].to_i,
      bookmarkable_type: params[:bookmark]["bookmarkable_type"],
      bookmarkable_id: params[:bookmark]["bookmarkable_id"].to_i
    )
    if @bookmark.save
      flash[:notice] = "Bookmarked!"
      redirect_to i_path
    else
      flash[:error] = "Something went wrong"
      redirect_to i_path
    end
  end

  def destroy
    bm = current_user.bookmarks.find_by(
      bookmarkable_type: params[:bookmark]["bookmarkable_type"],
      bookmarkable_id:   params[:bookmark]["bookmarkable_id"]
    )
    if bm.delete
      flash[:notice] = "Bookmark removed"
      redirect_to i_path
    else
      flash[:error] = "Something went wrong."
      redirect_to i_path
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :bookmarkable_type, :bookmarkable_id)
  end

  def find_bookmarkable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
