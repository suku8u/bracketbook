class BracketsController < ApplicationController
  before_filter :get_all_bracket_info, :only => [:show, :edit]

  # GET /brackets
  # GET /brackets.json
  def index
    @brackets = Bracket.all

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
    @show_edit_match = true
    @teams = @bracket.teams
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bracket }
    end
  end

  # POST /brackets
  # POST /brackets.json
  def create
    @bracket = Bracket.new(params[:bracket])
    #raise params[:bracket][:bracket_teams].inspect
    bracket_teams = params[:bracket][:bracket_teams].split(/\r?\n/)
    #raise bracket_teams.inspect

    respond_to do |format|
      if @bracket.save
        # save teams to bracket
        bracket_teams.each do |t|
          team = @bracket.teams.build
          team.name = t
          team.save
        end

        # generate correct number of matches for this bracket
        case @bracket.teams.count
        when 2..4
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

        half_num_matches = num_matches / 2

        bracket_position_counter = 0
        num_matches.times do
          bracket_position_counter += 1
          match = @bracket.matches.build
          match.bracket_position = bracket_position_counter
          match.save
        end

        matches = @bracket.matches

        # insert two teams into each match
        counter = 0
        @bracket.teams.each_slice(2) do |two_teams|
          matches[counter].team1_id = two_teams[0].id
          matches[counter].team2_id = two_teams[1].id
          matches[counter].save
          counter += 1
        end

        # create next match connections
        increment = true
        increment_value = -1
        matches.each_with_index do |match, index|
         if increment == true
            increment_value += 1
            increment = false
          elsif increment == false
            increment = true
          end
          match.next_match_id = matches[half_num_matches + increment_value].id
          match.save
        end


        format.html { redirect_to @bracket, notice: 'Bracket was successfully created.' }
        format.json { render json: @bracket, status: :created, location: @bracket }
      else
        format.html { render action: "new" }
        format.json { render json: @bracket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brackets/1
  # PUT /brackets/1.json
  def update
    @bracket = Bracket.find(params[:id])

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
    @bracket.destroy

    respond_to do |format|
      format.html { redirect_to brackets_url }
      format.json { head :no_content }
    end
  end

  def generator
    @bracket = Bracket.new
  end

  private

  def get_all_bracket_info
    @bracket = Bracket.find(params[:id])
    matches = @bracket.matches
    num_matches = @bracket.matches.count
    @matches_in_each_round = []
    while num_matches > 0
      num_matches = num_matches / 2
      @matches_in_each_round << num_matches if num_matches > 0
    end

    @matches = matches.map do |match|
      team1_name = ""
      team2_name = ""
      team1_score = "?"
      team2_score = "?"
      edit_path = ""

      team1_name = Team.find_by_id(match.team1_id).name.truncate(18) unless match.team1_id.nil?
      team2_name = Team.find_by_id(match.team2_id).name.truncate(18) unless match.team2_id.nil?
      team1_score = match.team1_score unless match.team1_score.nil?
      team2_score = match.team2_score unless match.team2_score.nil?
      edit_path = edit_bracket_match_path(match) unless match.team1_id.nil? || match.team2_id.nil?



      {
        team1_name: team1_name,
        team2_name: team2_name,
        team1_score: team1_score,
        team2_score: team2_score,
        edit_path: edit_path
      }
    end
  end
end
