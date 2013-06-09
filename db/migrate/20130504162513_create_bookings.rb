class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :court_number
      t.datetime :playing_at
      t.integer :opponent_id

      t.timestamps
    end
  end
end
