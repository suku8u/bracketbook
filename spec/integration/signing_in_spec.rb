require 'spec_helper'

feature 'Signin in' do

  before do
    Factory(:user, :email => 'user@example.com')
  end

  scenario 'Signing in via form' do
    visit '/'
    click_link 'Log in'
    fill_in 'Email', :with => 'user@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    page.should have_content("Signed in successfully.")
  end

end
