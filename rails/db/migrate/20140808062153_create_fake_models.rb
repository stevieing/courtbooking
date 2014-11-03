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

      unless table_exists?(:slot_testers)
        create_table :slot_testers do |t|
          t.string :time_from
          t.string :time_to
        end
      end

      unless table_exists?(:blog_posts)
        create_table :blog_posts do |t|
          t.string :title
        end
      end

      unless table_exists?(:comments)
        create_table :comments do |t|
          t.integer :blog_post_id
          t.string :text
        end
      end

      unless table_exists?(:fake_settings)
        create_table :fake_settings do |t|
          t.string :name
          t.string :value
          t.string :description
        end
      end
    end
  end
end
