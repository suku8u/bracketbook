require 'spec_helper'

feature "Deleting brackets" do

  before do
    user = Factory(:user, :email => 'user@example.com')
    sign_in_as!(user)
    click_link 'New Bracket'
    fill_in 'Name', :with => 'The Line Bounced'
    fill_in 'bracket_bracket_teams', :with => "team a\n team b\nteam c\nteam d"
    click_button 'Save Bracket'
    click_link 'Edit this bracket'
  end

  scenario "Deleting a project" do
    click_link 'Delete Bracket'
    page.should_not have_content('The Line Bounced')
    page.should have_content('Bracket was successfully deleted.')
  end
end
