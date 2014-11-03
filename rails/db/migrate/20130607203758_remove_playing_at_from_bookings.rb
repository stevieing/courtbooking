class RemovePlayingAtFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :playing_at
  end

  def down
    add_column :bookings, :playing_at, :datetime
  end
end
