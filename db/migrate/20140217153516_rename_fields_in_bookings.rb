class RenameFieldsInBookings < ActiveRecord::Migration
  def change
  	rename_column :bookings, :playing_from, :time_from
    rename_column :bookings, :playing_to, :time_to
  end
end
