require "test_helper"

class BookingsFormTest < ActiveSupport::TestCase

  def setup
    stub_dates("16 September 2013", "09:00")
    stub_settings
    @bookings_form = BookingsForm.new
    @court = create(:court_with_opening_and_peak_times)
    @user = create(:user)
  end

  test "should create a booking when submitted with valid attributes" do
    @bookings_form.submit(attributes_for(:booking, court_id: @court.id, date_from: Date.today+1), @user)
    assert @bookings_form.valid?
    assert_equal 1, Booking.count
  end

  test "should not create a booking when submitted with invalid attributes" do
    @bookings_form.submit(attributes_for(:booking, court_id: @court.id, date_from: nil), @user)
    refute @bookings_form.valid?
    assert_equal 0, Booking.count
  end

  test "should create a booking when time_and_place is used" do
    @attributes = attributes_for(:booking)
    @params = {time_and_place: "#{@attributes[:date_from].to_s(:uk)} "}
  end

end