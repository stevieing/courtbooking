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

  test "a newly added court slot should be findable by its id" do
    assert_equal court_slot, Slots::CourtSlot.find(court_slot.id)
  end

  test "it should return a json response" do
    assert_equal "{\"court_slot\":{\"id\":#{court_slot.id},\"from\":\"#{court_slot.from}\",\"to\":\"#{court_slot.to}\",\"court_id\":#{court_slot.court_id}}}", court_slot.to_json
  end

end