class RenameFieldsInCourtTimes < ActiveRecord::Migration
  def change
    rename_column :court_times, :from, :time_from
    rename_column :court_times, :to, :time_to
  end
end
