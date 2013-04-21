class BracketsController < ApplicationController
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
    @bracket = Bracket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bracket }
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
    @bracket = Bracket.find(params[:id])
  end

  # POST /brackets
  # POST /brackets.json
  def create
    @bracket = Bracket.new(params[:bracket])

    respond_to do |format|
      if @bracket.save
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
        format.html { redirect_to @bracket, notice: 'Bracket was successfully updated.' }
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
end
