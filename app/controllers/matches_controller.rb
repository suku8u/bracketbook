class MatchesController < ApplicationController
  before_filter :find_and_authorize_bracket

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.json
  def new
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @bracket = Bracket.find(params[:bracket_id])
    @match = @bracket.matches.find(params[:id])
    @team1_name = Team.find(@match.team1_id).name
    @team2_name = Team.find(@match.team2_id).name
    @team1_name = "Bye" if @team1_name.blank?
    @team2_name = "Bye" if @team2_name.blank?
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render json: @match, status: :created, location: @match }
      else
        format.html { render action: "new" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.json
  def update
    @bracket = Bracket.find(params[:bracket_id])
    @match = @bracket.matches.find(params[:id])
    next_match = @bracket.matches.find(@match.next_match_id)
    is_odd_match = @match.bracket_position.odd?
    winning_team_id = nil

    respond_to do |format|
      if @match.update_attributes(params[:match])

        if @match.team1_score > @match.team2_score
          winning_team_id = @match.team1_id
        elsif @match.team2_score > @match.team1_score
          winning_team_id = @match.team2_id
        end

        unless winning_team_id.nil?
          if is_odd_match
            next_match.team1_id = winning_team_id
          else
            next_match.team2_id = winning_team_id
          end
          next_match.save
        end

        format.html { redirect_to edit_bracket_path(@bracket), notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end
end
