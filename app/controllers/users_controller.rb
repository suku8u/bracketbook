class UsersController < ApplicationController
  def show
    @user = User.includes(:brackets).find_by_username(params[:id])
    @brackets = @user.brackets.page(params[:page]).per_page(25)
  end
end
