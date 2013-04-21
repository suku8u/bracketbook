class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :team1_id
      t.integer :team2_id
      t.integer :team1_score
      t.integer :team2_score
      t.references :bracket

      t.timestamps
    end
    add_index :matches, :bracket_id
  end
end
