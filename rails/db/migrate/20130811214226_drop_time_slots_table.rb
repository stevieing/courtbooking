class DropTimeSlotsTable < ActiveRecord::Migration
  def up
    drop_table :time_slots
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
