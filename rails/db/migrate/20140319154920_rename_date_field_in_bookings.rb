class RenameDateFieldInBookings < ActiveRecord::Migration
  def change
    rename_column :bookings, :playing_on, :date_from
  end
end
