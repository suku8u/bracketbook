require 'spec_helper'

describe "brackets/edit" do
  before(:each) do
    @bracket = assign(:bracket, stub_model(Bracket,
      :name => "MyString"
    ))
  end

  it "renders the edit bracket form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bracket_path(@bracket), "post" do
      assert_select "input#bracket_name[name=?]", "bracket[name]"
    end
  end
end
