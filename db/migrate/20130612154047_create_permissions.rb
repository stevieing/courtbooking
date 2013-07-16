class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :controller
      t.string :actions
      t.string :resource
      t.string :attrs
      t.string :type

      t.timestamps
    end
  end
end
