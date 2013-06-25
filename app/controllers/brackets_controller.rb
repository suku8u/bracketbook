class BracketsController < ApplicationController
  before_filter :get_private_bracket_info, :only => [:edit, :update]
  before_filter :get_public_bracket_info, :only => [:show]

  # GET /brackets
  # GET /brackets.json
  def index
    @brackets = Bracket.viewable_by(current_user).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brackets }
    end
  end

  # GET /brackets/1
  # GET /brackets/1.json
  def show
    @show_edit_match = false
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @matches.to_json }
    end
  end

  # GET /brackets/new
  # GET /brackets/new.json
  def new
    @bracket = Bracket.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bracket }
    end
  end

  # GET /brackets/1/edit
  def edit
    @allow_edit = true
    authorize! :edit, @bracket
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bracket }
    end
  end

  # POST /brackets
  # POST /brackets.json
  def create
    @bracket = Bracket.new(params[:bracket])
    bracket_teams = params[:bracket][:bracket_teams].split(/\r?\n/)

    respond_to do |format|
      if Bracket.create_bracket @bracket, bracket_teams, current_user
        format.html { redirect_to @bracket, notice: 'Bracket was successfully created.' }
        format.json { render json: @bracket, status: :created, location: @bracket }
      else
        flash[:error] = "There was an error saving your bracket. Please try again."
        format.html { render action: "new" }
        format.json { render json: @bracket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brackets/1
  # PUT /brackets/1.json
  def update
    @bracket = Bracket.find(params[:id])
    authorize! :update, @bracket
    respond_to do |format|
      if @bracket.update_attributes(params[:bracket])
        format.html { redirect_to edit_bracket_path(@bracket), notice: 'Bracket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bracket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brackets/1
  # DELETE /brackets/1.json
  def destroy
    @bracket = Bracket.find(params[:id])
    authorize! :delete, @bracket
    @bracket.destroy

    respond_to do |format|
      format.html { redirect_to brackets_url, notice: 'Bracket was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def generator
    @bracket = Bracket.new
  end

  private

  def get_private_bracket_info
    begin
      @bracket = Bracket.includes(:matches,:teams).viewable_by(current_user).find(params[:id])
      matches = @bracket.matches
      teams = @bracket.teams
      @matches_in_each_round = matches_in_each_round matches.count
      @matches = get_matches_info_array @bracket, matches, teams
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The bracket you were looking" +
      " for could not be found."
      redirect_to brackets_path
    end
  end

  def get_public_bracket_info
    @bracket = Bracket.includes(:matches, :teams).find(params[:id])
    matches = @bracket.matches
    teams = @bracket.teams
    @matches_in_each_round = matches_in_each_round matches.count
    @matches = get_matches_info_array @bracket, matches, teams
  end

  def get_matches_info_array bracket, matches, teams
    matches_array = matches.map do |match|
      team1_name = ""
      team2_name = ""
      team1_score = ""
      team2_score = ""
      match_edit_path = ""
      team1_edit_path = ""
      team2_edit_path = ""

      team1 = find_team_in_array match.team1_id, teams
      team2 = find_team_in_array match.team2_id, teams
      team1_name = team1.name.truncate(18) unless match.team1_id.nil?
      team2_name = team2.name.truncate(18) unless match.team2_id.nil?
      team1_score = match.team1_score unless match.team1_score.nil?
      team2_score = match.team2_score unless match.team2_score.nil?
      match_edit_path = edit_bracket_match_path(bracket, match) unless match.team1_id.nil? || match.team2_id.nil?
      team1_edit_path = edit_bracket_team_path(bracket, team1) unless team1.nil?
      team2_edit_path = edit_bracket_team_path(bracket, team2) unless team2.nil?

      {
        team1_name: team1_name,
        team2_name: team2_name,
        team1_score: team1_score,
        team2_score: team2_score,
        match_edit_path: match_edit_path,
        team1_edit_path: team1_edit_path,
        team2_edit_path: team2_edit_path
      }
    end

    return matches_array
  end

  def matches_in_each_round num_matches
    matches_in_each_round = []
    while num_matches > 1
      num_matches = num_matches / 2
      matches_in_each_round << num_matches if num_matches > 0
    end
    return matches_in_each_round
  end

  def find_team_in_array team_id, team_array
    team_array.each do |t|
      return t if t.id == team_id
    end
  end
end
