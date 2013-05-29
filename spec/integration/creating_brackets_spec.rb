require 'spec_helper'

feature 'Creating Brackets' do

  before do
    user = Factory(:user, :email => 'user@example.com')
    sign_in_as!(user)
    click_link 'New Bracket'
  end

  scenario "Try Bracket Generator takes you to correct page" do
    current_path.should == '/brackets/new'
    page.should have_selector('h1', :text => "New Bracket")
  end

  scenario "Can create a bracket" do
    fill_in 'Name', :with => 'The Line Bounced'
    fill_in 'bracket_bracket_teams', :with => "a\nb\nc\nd"
    click_button 'Save Bracket'
    page.should have_content('The Line Bounced')
  end

  scenario "Can preview a bracket", :js => true do
    fill_in "Name", :with => "The Line Bounced"
    fill_in 'bracket_bracket_teams', :with => "team a\nteam b\nteam c\nteam d"
    within("#bracket-box") do
      page.should have_content('team d')
    end
  end

end
