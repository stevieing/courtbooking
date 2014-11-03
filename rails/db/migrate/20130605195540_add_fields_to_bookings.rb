class AddFieldsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :playing_on, :date
    add_column :bookings, :playing_from, :string
    add_column :bookings, :playing_to, :string
  end
end
