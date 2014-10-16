class PagesController < ApplicationController
  before_filter :authenticate_user!, except: [:welcome]

  def welcome
    redirect_to dashboard_path if current_user
  end

  def suggestions
    @user = current_user
  end

  def intro
  end
end
