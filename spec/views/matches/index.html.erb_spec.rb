require 'spec_helper'

describe "matches/index" do
  before(:each) do
    assign(:matches, [
      stub_model(Match,
        :team1_id => 1,
        :team2_id => 2,
        :team1_score => 3,
        :team2_score => 4,
        :bracket => nil
      ),
      stub_model(Match,
        :team1_id => 1,
        :team2_id => 2,
        :team1_score => 3,
        :team2_score => 4,
        :bracket => nil
      )
    ])
  end

  it "renders a list of matches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
