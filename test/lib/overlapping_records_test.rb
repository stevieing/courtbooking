require "test_helper"

class OverlappingRecordsTest < ActiveSupport::TestCase

  attr_reader :courts

  def setup
    stub_dates("24 Mar 2014", "19:00")
    stub_settings
    @courts = create_list(:court, 4)
    create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "12:00", time_to: "19:00", courts: [courts.first, courts[1], courts[2]])
    create(:booking, date_from: Date.today+1, time_from: "19:00", time_to: "19:40", court: courts.first)
    create(:booking, date_from: Date.today+1, time_from: "19:00" , time_to: "19:40", court: courts.last)
    create(:event, date_from: Date.today+2, time_from: "19:00", time_to: "20:20", courts: [courts.first])
  end

  test "overlapping records should not be valid without a valid date from" do
    refute OverlappingRecords.new(build(:booking, date_from: "" )).valid?
  end

  test "overlapping records should not be valid without a valid time from" do
    refute OverlappingRecords.new(build(:booking, time_from: "" )).valid?
  end

  test "overlapping records should not be valid without a valid time to" do
    refute OverlappingRecords.new(build(:booking, time_to: "" )).valid?
  end

  test "overlapping records should not be valid without a valid court id" do
    refute OverlappingRecords.new(build(:booking, court_id: nil )).valid?
  end

  test "overlapping records should be valid with all attributes" do
    assert OverlappingRecords.new(build(:booking)).valid?
  end

  test "overlapping records should be empty when a booking doesn't overlap" do
    assert OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "18:20", time_to: "19:00", court: courts.last)).empty?
  end

  test "overlapping records should not be empty when a booking overlaps with a closure" do
    refute OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "12:00", time_to: "12:40", court: courts.first)).empty?
  end

  test "overlapping records should not be empty when a booking overlaps with a booking" do
    refute OverlappingRecords.new(build(:booking, date_from: Date.today+1, time_from: "19:00", time_to: "19:40", court: courts.first)).empty?
  end

  test "overlapping records should not be empty when a booking overlaps with an event" do
    refute OverlappingRecords.new(build(:booking, date_from: Date.today+2, time_from: "19:00", time_to: "19:40", court: courts.first)).empty?
  end

  test "overlapping records should be empty when an activity doesn't overlap with anything" do
    assert OverlappingRecords.new(build(:closure, date_from: Date.today+6, date_to: Date.today+7, time_from: "09:00", time_to: "12:00", courts: [courts.first])).empty?
  end

  test "overlapping records should not be empty when an activity overlaps with another activity" do
    refute OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+4, time_from: "14:00", time_to: "16:00", courts: [courts.first, courts.last])).empty?
    refute OverlappingRecords.new(build(:closure, date_from: Date.today+2, date_to: Date.today+6, time_from: "19:00", time_to: "20:20", courts: [courts.first, courts.last])).empty?
  end

  test "overlapping records should not be empty when an activity overlaps with a booking" do
    refute OverlappingRecords.new(build(:closure, date_from: Date.today+1, date_to: Date.today+2, time_from: "19:00", time_to: "20:20", courts: [courts.first])).empty?

  end

end