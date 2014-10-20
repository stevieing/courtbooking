require "test_helper"
require File.expand_path(Rails.root.join('test','fakes','slot_tester.rb'))


class ActiveRecordSlotsTest < ActiveSupport::TestCase

  test "adding module to any old model with correct attributes should work" do
    slot_tester = SlotTester.new(time_from: "08:00", time_to: "08:30")
    assert slot_tester.slot.valid?
    assert_equal "08:00", slot_tester.slot.from
    assert_equal "08:30", slot_tester.slot.to
  end

  test "booking slot should be valid" do
    booking = build(:booking)
    assert booking.slot.valid?
  end

  test "activity slot should be valid" do
    stub_settings
    event = build(:event)
    assert event.slot.valid?
  end
end
