class Team < ActiveRecord::Base
  belongs_to :bracket
  attr_accessible :name

  validates :name, :presence => true
end
