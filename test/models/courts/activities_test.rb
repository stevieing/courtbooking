require "test_helper"

class ActivitiesTest < ActiveSupport::TestCase

  attr_reader :courts, :slots

  def setup
    stub_settings
    @options = {slot_first: "06:20", slot_last: "09:00", slot_time: 40}
    @courts = create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "06:20", opening_time_to: "09:00")
    @slots = Slots::Base.new(options.merge(courts: courts))
  end

  test "closures for all courts should remove correct rows and create message" do
    closure = create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "06:20", time_to: "07:00", courts: courts)
    activities = Courts::Activities.new(slots, Date.today+1, courts)
    activities.process!
    assert_nil slots.grid.find("06:20")
    refute_nil slots.grid.find("07:00")
    assert_equal closure.message, activities.closure_message
  end

  test "closures should be added to slots" do
    closure1 = create(:closure, date_from: Date.today+1, date_to: Date.today+4, time_from: "06:20", courts: [courts.first])
    closure2 = create(:closure, date_from: Date.today+1, date_to: Date.today+3, time_from: "08:20", courts: [courts.last])
    activities = Courts::Activities.new(slots, Date.today+1, courts)
    activities.process!
    assert_equal :activity, slots.grid.find("06:20", courts.first.id).type
    assert_equal closure1.description, slots.grid.find("06:20", courts.first.id).text
    assert_equal :activity, slots.grid.find("08:20", courts.last.id).type
    assert_equal closure2.description, slots.grid.find("08:20", courts.last.id).text
  end

   test "events should be added to slots" do
    event1 = create(:event, date_from: Date.today+1, time_from: "06:20", courts: [courts.first])
    event2 = create(:event, date_from: Date.today+1, time_from: "08:20", courts: [courts.last])
    activities = Courts::Activities.new(slots, Date.today+1, courts)
    activities.process!
    assert_equal :activity, slots.grid.find("06:20", courts.first.id).type
    assert_equal event1.description, slots.grid.find("06:20", courts.first.id).text
    assert_equal :activity, slots.grid.find("08:20", courts.last.id).type
    assert_equal event1.description, slots.grid.find("08:20", courts.last.id).text
  end


end