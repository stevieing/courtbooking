class CreateOccurrences < ActiveRecord::Migration
  def change
    create_table :occurrences do |t|
    	t.belongs_to :activity
    	t.belongs_to :court
    	t.timestamps
    end
    add_index :occurrences, :activity_id
    add_index :occurrences, :court_id
  end
end
