class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :allowed_action_id
      t.integer :user_id

      t.timestamps
    end
  end
end
