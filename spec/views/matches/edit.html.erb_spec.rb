require 'spec_helper'

describe "matches/edit" do
  before(:each) do
    @match = assign(:match, stub_model(Match,
      :team1_id => 1,
      :team2_id => 1,
      :team1_score => 1,
      :team2_score => 1,
      :bracket => nil
    ))
  end

  it "renders the edit match form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", match_path(@match), "post" do
      assert_select "input#match_team1_id[name=?]", "match[team1_id]"
      assert_select "input#match_team2_id[name=?]", "match[team2_id]"
      assert_select "input#match_team1_score[name=?]", "match[team1_score]"
      assert_select "input#match_team2_score[name=?]", "match[team2_score]"
      assert_select "input#match_bracket[name=?]", "match[bracket]"
    end
  end
end
