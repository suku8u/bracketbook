require 'spec_helper'

describe "brackets/show" do
  before(:each) do
    @bracket = assign(:bracket, stub_model(Bracket,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
