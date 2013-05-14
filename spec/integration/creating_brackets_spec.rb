require 'spec_helper'

feature 'Creating Projects' do

  before do
    visit '/'
    click_link 'Try Bracket Generator'
  end

  scenario "Try Bracket Generator takes you to correct page" do
    current_path.should == '/brackets/generator'
    page.should have_button('Generate Bracket')
    # save_and_open_page
  end

  scenario "can create a bracket" do
    # save_and_open_page
    fill_in 'Name', :with => 'The Line Bounced'
    fill_in 'bracket_bracket_teams', :with => "a\nb\nc\nd"
    click_button 'Save Bracket'
    page.should have_content('The Line Bounced')
    #page.should have_content('Save Bracket')
    #page.should have_content('Edit Bracket')
  end

end
