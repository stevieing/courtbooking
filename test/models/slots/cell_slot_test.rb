require "test_helper"

class CellSlotTest < ActiveSupport::TestCase

  attr_reader :slot, :cell_slot, :court

  def setup
    @slot = Slots::Slot.new("06:30","07:00")
    @court = create(:court)
    @cell_slot = Slots::CellSlot.new(court, slot)
  end

  test "new cell slot should have correct attributes" do
    assert_equal slot.from, cell_slot.from
    assert_equal slot.to, cell_slot.to
    assert_equal court.id, cell_slot.court_id
    assert_operator cell_slot.id, :>=, 1
  end

  test "new cell slot should not be filled with a cell" do
    assert_equal :empty, cell_slot.cell.type
    assert cell_slot.unfilled?
  end

  test "#fill should fill slot with a cell" do
    cell = Table::Cell::Blank.new
    cell_slot.fill(cell)
    assert cell_slot.filled?
    assert cell_slot.cell.blank?
  end

  test "#dup should create a new cell but not a new slot" do
    dupped_slot = cell_slot.dup
    cell_slot.fill(Table::Cell::Text.new)
    assert_equal :text, cell_slot.cell.type
    assert_equal :empty, dupped_slot.cell.type
    assert_equal cell_slot.id, dupped_slot.id
    assert_equal cell_slot.slot, dupped_slot.slot
  end

  test "#fill_with_booking should fill cell with a booking cell" do
    cell_slot.fill_with_booking(date: Date.today+2)
    assert_equal :booking, cell_slot.cell.type
  end

  test "#fill_with_activitiy should fill cell with an activity" do
    stub_settings
    activity = build(:activity)
    cell_slot.fill_with_activity(activity, activity.time_from)
    assert_equal :activity, cell_slot.cell.type
  end

  test "#close should close slot" do
    cell_slot.close
    assert cell_slot.cell.closed?
  end

end