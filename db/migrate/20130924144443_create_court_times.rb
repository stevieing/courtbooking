class CreateCourtTimes < ActiveRecord::Migration
  def change
    create_table :court_times do |t|
      t.integer :court_id
      t.integer :day
      t.string :from
      t.string :to
      t.string :type
      t.timestamps
    end
  end
end