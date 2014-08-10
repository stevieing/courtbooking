class CreateFakeModels < ActiveRecord::Migration
  def change
    if Rails.env.test?
      unless table_exists?(:basic_models)
        create_table :basic_models do |t|
          t.string :attr_a
          t.string :attr_b
          t.integer :attr_c

          t.timestamps
        end
      end
    end
  end
end
