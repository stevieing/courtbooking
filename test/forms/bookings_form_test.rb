require "test_helper"

class BookingsFormTest < ActiveSupport::TestCase

  def setup
    stub_dates("16 September 2013", "09:00")
    stub_settings
    @user = create(:member)
    @court = create(:court_with_opening_and_peak_times)
    @bookings_form = BookingsForm.new(@user)
  end

  test "should create a booking when submitted with valid attributes" do
    @bookings_form.submit(attributes_for(:booking, court_id: @court.id, date_from: Date.today+1))
    assert @bookings_form.valid?
    assert_equal 1, Booking.count
  end

  test "should not create a booking when submitted with invalid attributes" do
    @bookings_form.submit(attributes_for(:booking, court_id: @court.id, date_from: nil))
    refute @bookings_form.valid?
    assert_equal 0, Booking.count
  end

  test "new booking should be created when attributes are passed" do
    @attributes = ActionController::Parameters.new(attributes_for(:booking, court_id: @court.id, date_from: Date.today+1))
    @bookings_form = BookingsForm.new(@user, @attributes)
    assert_equal @attributes[:date_from], @bookings_form.date_from
    assert_equal @attributes[:court_id], @bookings_form.court_id
    assert_equal @attributes[:time_from], @bookings_form.time_from
    assert_equal @attributes[:time_to], @bookings_form.time_to
  end

  test "booking should be added when booking is passed" do
    @booking = build(:booking, court_id: @court.id, date_from: Date.today+1)
    @bookings_form = BookingsForm.new(@user, @booking)
    assert_equal @booking, @bookings_form.booking
  end

  test "booking should be updated with valid attributes" do
    @bookings_form = BookingsForm.new(@user, create(:booking, court_id: @court.id, date_from: Date.today+1))
    @bookings_form.submit(attributes_for(:booking, court_id: @court.id, date_from: Date.today+2))
    assert @bookings_form.valid?
    assert_equal 1, Booking.count
    assert_equal Date.today+2, @bookings_form.date_from
  end

end