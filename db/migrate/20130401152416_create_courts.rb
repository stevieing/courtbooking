class CreateCourts < ActiveRecord::Migration
  def change
    create_table :courts do |t|
      t.integer :number

      t.timestamps
    end
  end
end
