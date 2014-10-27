require 'test_helper'
require 'rails/performance_test_help'

class CourtsPageTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  # This really needs to be the full whack to find out where the bottlenecks are
  # It performs fine with no bookings or activities but once it is filled up it
  # slows down by 2 or 3 times.

  attr_reader :courts, :slots

  def setup
    stub_settings
    @courts = create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "06:20", opening_time_to: "22:20")
    @slots = Slots::Base.new(slot_first: "06:20", slot_last: "22:20", slot_time: 40, courts: courts)
    create_list(:court_with_opening_and_peak_times, 4)
    add_bookings
    AppSettings.const.stubs(:slots).returns(slots)
  end

  test "courtspage" do
    get "/courts/#{Date.today+1}"
  end

  def teardown
    Court.all.each do |court|
      court.destroy
    end
    User.delete_all
    Booking.delete_all
  end

private

  def add_bookings
    user = create(:user)
    booking_slots = ["17:40","18:20","19:00","19:40","20:20","21:00"]
    booking_slots.each_with_index do |slot, i|
      courts.each do |court|
        unless slot == booking_slots.last
          create(:booking, date_from: Date.today+1, time_from: slot, time_to: booking_slots[i+1], user: user)
        end
      end
    end
  end

end
