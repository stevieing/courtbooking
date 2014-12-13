require "test_helper"

class BookingFormTest < ActiveSupport::TestCase

  attr_reader :user, :court, :court_slot, :booking_form

  def setup
    stub_dates("16 September 2013", "09:00")
    stub_settings
    @user = create(:member)
    @court = create(:court_with_opening_and_peak_times)
    @court_slot = build(:court_slot, court: @court, slot: Slots::Slot.new(from: "10:20", to: "11:00"))
    Settings.slots.stubs(:find_by_id).returns(@court_slot)
    @booking_form = BookingForm.new(@user)
  end

  test "should create a booking when submitted with valid attributes" do
    booking_form.submit(attributes_for(:booking, court_id: court.id, date_from: Date.today+1))
    assert booking_form.valid?
    assert_equal 1, Booking.count
  end

  test "should not create a booking when submitted with invalid attributes" do
    booking_form.submit(attributes_for(:booking, court_id: @court.id, date_from: nil))
    refute @booking_form.valid?
    assert_equal 0, Booking.count
  end

  test "new booking should be created when attributes are passed" do
    attributes = ActionController::Parameters.new(court_slot_id: court_slot.id.to_s, date_from: Date.today+1)
    booking_form = BookingForm.new(user, attributes)
    assert_equal attributes[:date_from], booking_form.date_from
    assert_equal court_slot.court_id, booking_form.court_id
    assert_equal court_slot.from, booking_form.time_from
    assert_equal court_slot.to, booking_form.time_to
  end

  test "booking should be added when booking is passed" do
    booking = build(:booking, court_id: court.id, date_from: Date.today+1)
    booking_form = BookingForm.new(user, booking)
    assert_equal booking, booking_form.booking
  end

  test "new booking form should be fine when no attributes are passed" do
    booking_form = BookingForm.new(user)
    assert_instance_of Booking, booking_form.booking
  end

  test "booking should be updated with valid attributes" do
    booking_form = BookingForm.new(user, create(:booking, court_id: court.id, date_from: Date.today+1))
    booking_form.submit(attributes_for(:booking, court_id: court.id, date_from: Date.today+2))
    assert booking_form.valid?
    assert_equal 1, Booking.count
    assert_equal Date.today+2, booking_form.date_from
  end

end