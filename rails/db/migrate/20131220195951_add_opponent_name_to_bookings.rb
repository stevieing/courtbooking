class AddOpponentNameToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :opponent_name, :string
  end
end
