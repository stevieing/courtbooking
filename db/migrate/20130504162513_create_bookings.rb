class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :court_number
      t.datetime :booking_datetime
      t.integer :opponent_user_id

      t.timestamps
    end
  end
end
