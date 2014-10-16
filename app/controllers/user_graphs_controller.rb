class UserGraphsController < ApplicationController
  before_filter :authenticate_user!

  layout nil
  def show
    render :layout => false
  end

end
