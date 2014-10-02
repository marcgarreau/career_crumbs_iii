class PagesController < ApplicationController
  def welcome
  end

  def i
    @user = current_user
  end
end
