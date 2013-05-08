class Match < ActiveRecord::Base
  belongs_to :bracket
  attr_accessible :team1_id, :team1_score, :team2_id, :team2_score

  validates :team1_score, :numericality => { :only_integer => true }
  validates :team2_score, :numericality => { :only_integer => true }
end
