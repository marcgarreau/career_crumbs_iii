class PagesController < ApplicationController
  def welcome
  end

  def profile
    @user = current_user
  end
end
