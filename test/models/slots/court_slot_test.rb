require "test_helper"

class CourtSlotTest < ActiveSupport::TestCase

  attr_reader :slot, :court_slot, :court

  def setup
    @slot = Slots::Slot.new("06:30","07:00")
    @court = create(:court)
    @court_slot = Slots::CourtSlot.new(court, slot)
  end

  test "new court slot should have correct attributes" do
    assert_equal slot.from, court_slot.from
    assert_equal slot.to, court_slot.to
    assert_equal court.id, court_slot.court_id
    assert_operator court_slot.id, :>=, 1
  end

  test "new court slot should add id sequentially" do
    assert_equal court_slot.id+1, Slots::CourtSlot.new(court, slot).id
  end

  test "new court slot should not be filled with a cell" do
    assert_instance_of Table::Cell::NullCell, court_slot.cell
    assert court_slot.unfilled?
  end

  test "#fill should fill slot with a cell" do
    cell = Table::Cell::Blank.new
    court_slot.fill(cell)
    assert court_slot.filled?
    assert court_slot.cell.blank?
  end

  test "#dup should create a new cell" do
    dupped_slot = court_slot.dup
    court_slot.fill(Table::Cell::Text.new)
    assert_instance_of Table::Cell::Text, court_slot.cell
    assert_instance_of Table::Cell::NullCell, dupped_slot.cell
    assert_equal court_slot.id, dupped_slot.id
  end

  test "#fill_with_booking should fill cell with a booking cell" do
    court_slot.fill_with_booking(date: Date.today+2)
    assert_instance_of Table::Cell::Booking, court_slot.cell
  end

end