class Bracket < ActiveRecord::Base
  before_save :set_uuid
  attr_accessible :name, :bracket_teams
  has_many :teams, :dependent => :delete_all, :order => 'id ASC'
  has_many :matches, :dependent => :delete_all, :order => 'id ASC'

  validates :name, :presence => true

  has_many :permissions, :as => :thing
  extend FriendlyId
  friendly_id :slug, use: :slugged

  def set_uuid
    self.slug = SecureRandom.uuid[0..7] if self.slug.nil?
  end

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

  # create_bracket is used to create and save a bracket.
  # it is saved along with all of it's matches,
  # match connections, teams, and permissions.
  # it is done in a transaction to ensure all is saved.
  # params: bracket instance, array of team names, user
  def self.create_bracket bracket, bracket_teams, current_user

    if teams_invalid? bracket_teams
      return false
    end

    if bracket.invalid?
      return false
    end

    begin
      ActiveRecord::Base.transaction do

        # save bracket
        bracket.save

        # get the number of teams
        bracket_teams_count = bracket_teams.count

        # calculate correct number of matches for this bracket
        num_matches = Bracket.calculate_matches bracket_teams_count

        # calculate difference of num_matches and bracket_teams_count
        difference = num_matches - bracket_teams_count

        # fill in the rest of the missing spots with a Bye
        difference.times { bracket_teams << "Bye" }

        # save teams to bracket
        save_teams_to_bracket bracket, bracket_teams

        # create and save matches with position number
        create_and_save_matches bracket, num_matches

        # get all matches from this bracket
        matches = bracket.matches

        # insert two teams into each match
        assign_teams_to_matches bracket, matches

        # create next match connections
        create_next_match_connections matches, num_matches

        # set permissions
        set_permissions_for_bracket bracket, current_user
      end
    rescue
      return false
    end
  end

private

  def self.calculate_matches bracket_teams_count
    case bracket_teams_count
    when 1..4
      num_matches = 4
    when 5..8
      num_matches = 8
    when 8..16
      num_matches = 16
    when 16..32
      num_matches = 32
    else
      num_matches = 0
    end
    num_matches
  end

  def self.save_teams_to_bracket bracket, bracket_teams
    bracket_teams.each do |t|
      team = bracket.teams.build
      if t.blank?
        team.name = "Bye"
      else
        team.name = t
      end
      team.save
    end
  end

  def self.create_and_save_matches bracket, num_matches
    bracket_position_counter = 0
    num_matches.times do
      bracket_position_counter += 1
      match = bracket.matches.build
      match.bracket_position = bracket_position_counter
      match.save
    end
  end

  def self.assign_teams_to_matches bracket, matches
    counter = 0
    bracket.teams.each_slice(2) do |two_teams|
      matches[counter].team1_id = two_teams[0].id
      matches[counter].team2_id = two_teams[1].id
      matches[counter].save
      counter += 1
    end
  end

  def self.create_next_match_connections matches, num_matches
    half_num_matches = num_matches / 2
    increment = true
    increment_value = -1
    matches.each do |match|
      if increment == true
        increment_value += 1
        increment = false
      elsif increment == false
        increment = true
      end
      match.next_match_id = matches[half_num_matches + increment_value].id
      match.save
    end
  end

  def self.set_permissions_for_bracket bracket, current_user
    permissions = ["view", "edit", "update", "delete"]
    permissions.each do |permission|
      Permission.create!(:user => current_user,
      :thing => bracket,
      :action => permission)
    end
  end

  def self.teams_invalid? bracket_teams
    if bracket_teams.count < 2 || bracket_teams.count > 64
      return true
    end

    bracket_teams.each do |t|
      return true if t.length > 50
    end

    return false
  end
end
