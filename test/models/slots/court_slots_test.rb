require "test_helper"

class CourtSlotsTest < ActiveSupport::TestCase

  attr_reader :slots, :courts, :court_slots

  def setup
    @slots = build(:slots)
    @courts = create_list(:court, 4)
    @court_slots = Slots::CourtSlots.new(courts, slots.all)
  end

  test "Court slots should be valid" do
    assert court_slots.valid?
  end

  test "Court slots should have the correct number of court slots" do
    assert_equal slots.count*courts.count, court_slots.count
  end

  test "We should be able to find a court slot by its id" do
    court_slot = court_slots.all.values.first
    refute_nil court_slots.find_by_id(court_slot.id)
  end

  test "Court slots should have a valid table made up of slots" do
    assert_equal slots.count, court_slots.table.count
    assert_equal courts.count, court_slots.find(slots.first.from).count
    assert_equal court_slots.all.values.first, court_slots.find(slots.first.from, courts.first.id)
    assert_equal court_slots.all.values.last, court_slots.find(slots.last.from, courts.last.id)
  end

  test "#to_empty should return a dupped table filled with empty cells" do
    empty_table = court_slots.to_empty
    refute_equal court_slots.table, empty_table
    i = 0
    empty_table.unfilled { |cell| i += 1 }
    assert_equal slots.count*courts.count, i
    assert_equal court_slots.all.values.first, empty_table.find(slots.first.from, courts.first.id).slot
    assert_equal court_slots.all.values.last, empty_table.find(slots.last.from, courts.last.id).slot
  end

  test "#find should find correct slot" do
    slot = court_slots.find_by_id(court_slots.all.values.first.id)
    assert_equal slots.first.from, slot.from
    assert_equal courts.first.id, slot.court_id
  end



end