require 'spec_helper'

feature 'Editing Brackets' do

  before do
    user = Factory(:user, :email => 'user@example.com')
    sign_in_as!(user)
    click_link 'New Bracket'
    fill_in 'Name', :with => 'The Line Bounced'
    fill_in 'bracket_bracket_teams', :with => "team a\n team b\nteam c\nteam d"
    click_button 'Save Bracket'
    click_link 'Edit this bracket'
  end

  scenario "Can update the name" do
    fill_in 'bracket_name', :with => "The Sonics"
    click_button 'Update bracket name'
    page.should have_selector('h1', :text => "The Sonics")
  end

  scenario "Can update a match" do
    click_link 'Edit match'
    page.should have_content 'Editing match'
    fill_in 'match_team1_score', :with => "1"
    fill_in 'match_team2_score', :with => "2"
    click_button 'Update Match'
    page.should have_selector('span', :text => "1")
    page.should have_selector('span', :text => "2")

    # this is the hidden 0 score for team b which advanced to next round
    page.should have_selector('span.badge.hidden', :text => "0")
  end

  scenario "Can have a champion" do
    click_link 'Edit match'
    fill_in 'match_team1_score', :with => "1" # team a
    fill_in 'match_team2_score', :with => "2" # team b
    click_button 'Update Match'

    # click the second button with same name as first
    page.all('a.btn.btn-mini.btn-primary')[1].click
    fill_in 'match_team1_score', :with => "4" # team c
    fill_in 'match_team2_score', :with => "3" # team d
    click_button 'Update Match'

    # third and final match now exists
    page.all('a.btn.btn-mini.btn-primary')[2].click
    fill_in 'match_team1_score', :with => "5" # team b
    fill_in 'match_team2_score', :with => "6" # team c
    click_button 'Update Match'
    page.should have_selector('i.icon-star.icon-white', :text => "")
  end
end
