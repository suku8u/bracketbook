class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.references :bracket

      t.timestamps
    end
    add_index :teams, :bracket_id
  end
end
