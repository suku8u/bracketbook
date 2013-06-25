class UsersController < ApplicationController
  def show
    @user = User.includes(:brackets).find_by_username(params[:id])
  end
end
