class AddDefaultToMatchScores < ActiveRecord::Migration
  def change
    change_column :matches, :team1_score, :integer, :default => 0
    change_column :matches, :team2_score, :integer, :default => 0
  end
end
