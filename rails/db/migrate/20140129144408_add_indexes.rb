class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :bookings, :user_id
  	add_index :permissions, :allowed_action_id
  	add_index :court_times, :court_id
  end
end
