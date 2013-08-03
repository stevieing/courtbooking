class CreateAllowedActions < ActiveRecord::Migration
  def change
    create_table :allowed_actions do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.boolean :user_specific, :default => false

      t.timestamps
    end
  end
end
