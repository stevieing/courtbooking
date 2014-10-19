require "test_helper"

class BookingMailerTest < ActionMailer::TestCase

  attr_reader :booking

  def setup
    stub_settings
    @booking = create(:booking)
  end

  test "A booking confirmation should send a confirmation email" do
    mail = BookingMailer.booking_confirmation(booking)
    assert_equal "Booking Confirmation - Stamford Squash Club", mail.subject
    assert_equal [booking.user.email, booking.opponent.email], mail.to
    assert_equal ["bookings@stamfordsquashclub.org.uk"], mail.from
    assert_match "#{booking.time_and_place}", mail.body.encoded
  end

  test "A booking deletion should send a cancellation message" do
    mail = BookingMailer.booking_cancellation(booking)
    assert_equal "Booking Cancelled - Stamford Squash Club", mail.subject
    assert_equal [booking.user.email, booking.opponent.email], mail.to
    assert_equal ["bookings@stamfordsquashclub.org.uk"], mail.from
    assert_match "#{booking.time_and_place}", mail.body.encoded
  end

end