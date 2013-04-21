class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.string :start_time
      t.string :finish_time
      t.integer :slot_time
      t.string :slots
      t.timestamps
    end
  end
end
