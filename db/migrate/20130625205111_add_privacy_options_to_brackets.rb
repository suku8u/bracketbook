class AddPrivacyOptionsToBrackets < ActiveRecord::Migration
  def change
    add_column :brackets, :show_in_tournaments, :boolean, default: true
    add_column :brackets, :show_in_profile, :boolean, default: true
  end
end
