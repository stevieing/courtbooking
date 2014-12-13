require 'test_helper'
require File.expand_path(Rails.root.join('test','fakes','basic_model.rb'))

class ActiveRecordRelationTest < ActiveSupport::TestCase

  attr_reader :relations, :record1

  def setup
    @record1 = BasicModel.create(attr_a: "a", attr_b: "b", attr_c: 1)
    @record2 = BasicModel.create(attr_a: "a", attr_b: "c", attr_c: 2)
    @record3 = BasicModel.create(attr_a: "a", attr_b: "d", attr_c: 3)
    @record4 = BasicModel.create(attr_a: "b", attr_b: "b", attr_c: 4)
    @record5 = BasicModel.create(attr_a: "c", attr_b: "e", attr_c: 5)
    @relations = BasicModel.all
  end

  test "#select_first_or_initialize with an existing record should return that record" do
    assert_equal record1, relations.select_first_or_initialize(attr_a: "a", attr_b: "b") do |relation|
      relation.attr_c = 6
    end
  end

  test "#select_first_or_initialize with no record should create a new record" do
    record = relations.select_first_or_initialize(attr_a: "d", attr_b: "e") do |relation|
      relation.attr_c = 6
    end
    assert record.new_record?
    assert_equal "d", record.attr_a
    assert_equal "e", record.attr_b
    assert_equal 6, record.attr_c
  end

  test "#select_first_or_initialize with multiple results should return first record" do
     assert_equal record1, relations.select_first_or_initialize(attr_b: "b") do |relation|
      relation.attr_c = 6
    end
  end

  test "#slots should return slots for objects" do
    stub_settings
    opening_time_1 = create(:opening_time)
    opening_time_2 = create(:opening_time)
    opening_times = OpeningTime.all
    slots = opening_times.slots
    assert_equal opening_time_1.slot, slots.first
    assert_equal opening_time_2.slot, slots.last
  end

  test "#combine should combine all instances of an attribute" do
    assert_equal "aaabc", relations.combine(:attr_a)
    assert_equal 15, relations.combine(:attr_c)
  end

end