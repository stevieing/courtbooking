class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :user
      t.integer :court_number
      t.datetime :playing_at
      t.references :opponent

      t.timestamps
    end
    
  end
end
