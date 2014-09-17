require "test_helper"

class BaseTest < ActiveSupport::TestCase

  attr_reader :slots, :options

  def setup
    @options = {slot_first: "06:20", slot_last: "09:00", slot_time: 40}
    @slots = Slots::Base.new(@options)
  end

  test "new slots should create correct number of slots" do
    assert_equal 5, slots.all.count
  end

  test "new slots should be valid with correct attributes" do
    assert slots.valid?
  end

  test "new slots should create array of slots" do
    assert slots.all? { |slot| slot.instance_of? Slots::Slot }
  end

  test "new slots without court_ids should not create grid nor should it fail" do
    assert_nil slots.grid
  end

  test "new slots with court_ids should create grid" do
    slots = Slots::Base.new(options.merge(courts: create_list(:court, 4)))
    refute_nil slots.grid
  end

  test "#remove_slots should remove series from constraints and rows from grid" do
    slots = Slots::Base.new(options.merge(courts: create_list(:court, 4)))
    slots.remove_slots!(Slots::Slot.new("08:20","09:40", @slots.constraints))
    assert_equal 3, slots.constraints.series.count
    assert_equal 5, slots.grid.rows.count
  end

  test "dup should create new copy of constraints and deep copy of grid" do
    slots = Slots::Base.new(options.merge(courts: create_list(:court, 4)))
    new_slots = slots.dup
    new_slots.remove_slots!(Slots::Slot.new("08:20","09:40", @slots.constraints))
    assert_equal 5, slots.constraints.series.count
    assert_equal 7, slots.grid.rows.count
  end

end