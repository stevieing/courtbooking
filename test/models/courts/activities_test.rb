require "test_helper"

class ActivitiesTest < ActiveSupport::TestCase

  attr_reader :options, :courts, :slots

  def setup
    @options = {slot_first: "06:20", slot_last: "09:00", slot_time: 40}
    @courts = create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "06:20", opening_time_to: "09:00")
    @slots = Slots::Base.new(options.merge(courts: courts))
  end

  test "closures for all courts should remove correct rows" do
    closure = create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "06:20", time_to: "07:00", courts: courts)
    activities = Courts::Activities.new(slots, activities, Date.today+1)
    assert_nil slots.grid.find("06:20")
    refute_nil slots.grid.find("07:00")
  end

end