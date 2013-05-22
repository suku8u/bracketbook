class Bracket < ActiveRecord::Base
  attr_accessible :name, :bracket_teams
  has_many :teams, :dependent => :delete_all, :order => 'id ASC'
  has_many :matches, :dependent => :delete_all, :order => 'id ASC'

  validates :name, :presence => true

  has_many :permissions, :as => :thing

  def bracket_teams
    # virtual attribute so bracket teams text area not matched to db
  end

  def bracket_teams=(bracket_teams)
    # virtual attribute so bracket teams text area not matched to db
  end

  def self.viewable_by(user)
    joins(:permissions).where(:permissions => { :action => "view",
                                                :user_id => user.id })
  end
end
