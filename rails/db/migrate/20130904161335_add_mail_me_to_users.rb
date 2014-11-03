class AddMailMeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_me, :boolean, :default => true
  end
end
