class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :allowed_action
      t.references :user

      t.timestamps
    end
    
  end
end
