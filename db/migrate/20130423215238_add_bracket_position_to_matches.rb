class AddBracketPositionToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :bracket_position, :integer
  end
end
