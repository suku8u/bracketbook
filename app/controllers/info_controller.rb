class InfoController < ApplicationController
  def home
  end

  def about
  end

  def contact
  end

  def generator
  end

  def tournaments
    @brackets = Bracket.includes(:user).all
  end
end
