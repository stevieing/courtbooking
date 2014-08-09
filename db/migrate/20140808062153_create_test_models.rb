class CreateTestModels < ActiveRecord::Migration
  def change
    create_table :test_models do |t|
      t.string :attr_a
      t.string :attr_b
      t.integer :attr_c

      t.timestamps
    end
  end
end
