class Bracket < ActiveRecord::Base
  attr_accessible :name, :bracket_teams
  has_many :teams, :dependent => :delete_all, :order => 'id ASC'
  has_many :matches, :dependent => :delete_all, :order => 'id ASC'

  validates :name, :presence => true

  def bracket_teams
    # virtual attribute so bracket teams text area not matched to db
  end

  def bracket_teams=(bracket_teams)
    # virtual attribute so bracket teams text area not matched to db
  end
end
