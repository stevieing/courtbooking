class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :description
      t.datetime :date_from
      t.datetime :date_to
      t.string :time_from
      t.string :time_to
      t.string :type

      t.timestamps
    end
  end
end
