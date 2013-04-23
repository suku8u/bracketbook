class AddNextMatchIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :next_match_id, :integer
  end
end
