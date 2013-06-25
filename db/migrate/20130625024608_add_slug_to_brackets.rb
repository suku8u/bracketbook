class AddSlugToBrackets < ActiveRecord::Migration
  def change
    add_column :brackets, :slug, :string
    add_index :brackets, :slug
  end
end
