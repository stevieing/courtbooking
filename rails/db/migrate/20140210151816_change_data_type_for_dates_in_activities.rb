class ChangeDataTypeForDatesInActivities < ActiveRecord::Migration
  def change
  	change_column :activities, :date_from, :date
  	change_column :activities, :date_to, :date
  end
end
