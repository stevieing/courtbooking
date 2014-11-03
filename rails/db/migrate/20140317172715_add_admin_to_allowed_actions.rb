class AddAdminToAllowedActions < ActiveRecord::Migration
  def change
    add_column :allowed_actions, :admin, :boolean, :default => false
  end
end
