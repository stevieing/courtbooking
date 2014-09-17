require "test_helper"

class CourtSlotTest < ActiveSupport::TestCase

  attr_reader :slot, :court_slot

  def setup
    @slot = Slots::Slot.new("06:30","07:00")
    @court_slot = Slots::CourtSlot.new(1, @slot)
  end

  test "new court slot should have correct attributes" do
    assert_equal slot, court_slot.slot
    assert_equal 1, court_slot.court_id
    assert_operator court_slot.id, :>=, 1
  end

  test "new court slot should add id sequentially" do
    assert_equal court_slot.id+1, Slots::CourtSlot.new(1, slot).id
  end

  test "new court slot should not be filled with a cell" do
    assert_instance_of Slots::Cell::NullCell, court_slot.cell
    assert court_slot.unfilled?
  end

  test "#fill should fill slot with a cell" do
    cell = Slots::Cell::Blank.new
    court_slot.fill(cell)
    assert court_slot.filled?
    assert court_slot.cell.blank?
  end

end