class RenameCourtFieldInBookings < ActiveRecord::Migration
  def change
    rename_column :bookings, :court_number, :court_id
  end
end