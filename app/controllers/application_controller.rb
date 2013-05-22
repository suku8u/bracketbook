class ApplicationController < ActionController::Base
  protect_from_forgery

  def find_and_authorize_bracket
    @bracket = Bracket.find(params[:bracket_id])
    authorize! :edit, @bracket
  end
end
