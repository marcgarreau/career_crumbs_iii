class PagesController < ApplicationController

  def welcome
    redirect_to dashboard_path if current_user
  end

  def i
    @user = current_user
  end

  def intro
  end
end
