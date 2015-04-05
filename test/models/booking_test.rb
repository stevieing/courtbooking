require "test_helper"

class BookingTest < ActiveSupport::TestCase

  attr_reader :courts

  def setup
    stub_dates("16 September 2013", "09:00")
    create_settings_constant
    Settings.stubs(:days_bookings_can_be_made_in_advance).returns(15)
    Settings.stubs(:max_peak_hours_bookings_weekly).returns(2)
    Settings.stubs(:max_peak_hours_bookings_daily).returns(1)
  end

  test "booking should not be valid without user_id" do
    refute build(:booking, date_from: Date.today+1, user_id: nil).valid?
  end

  test "booking should not be valid without court_id" do
    refute build(:booking, date_from: Date.today+1, court_id: nil).valid?
  end

  test "booking should not be valid without date_from" do
    refute build(:booking, date_from: nil).valid?
  end

  test "booking should not be valid without time_from" do
    refute build(:booking, date_from: Date.today+1, time_from: nil).valid?
  end

  test "booking should not be valid without time_to" do
    refute build(:booking, date_from: Date.today+1, time_to: nil).valid?
  end

  test "booking should not be valid when date is in the past" do
    refute build(:booking, date_from: Date.today-1).valid?
  end

  test "time from should be in format hh:mm" do
    refute build(:booking, time_from: "1045").valid?
    refute build(:booking, time_from: "invalid").valid?
    refute build(:booking, time_from: "25:45").valid?
    refute build(:booking, time_from: "10:63").valid?
  end

  test "time to should be in format hh:mm" do
    refute build(:booking, time_to: "1045").valid?
    refute build(:booking, time_to: "invalid").valid?
    refute build(:booking, time_to: "25:45").valid?
    refute build(:booking, time_to: "10:63").valid?
  end

  test "booking should not be valid if it is too far into the future" do
    refute build(:booking, date_from: Date.today+16).valid?
    refute build(:booking, date_from: Date.today+15).valid?
  end

  test "booking should not be valid if time is in the past" do
    refute build(:booking, date_from: Date.today, time_from: (Time.now-30.minutes).to_s(:hrs_and_mins)).valid?
  end

  test "user should not be able to make more than the maximum amount of peak hours bookings during a day" do
    user = create(:member)
    court = create(:court_with_defined_opening_and_peak_times, peak_time_from: "17:00", peak_time_to: "19:00")
    create(:booking, user: user, court: court, date_from: Date.today+1, time_from: "17:00")
    booking = build(:booking, user: user, court: court, date_from: Date.today+1, time_from: "18:00")
    refute booking.valid?
    assert booking.errors.full_messages.include?("No more than 1 booking allowed during peak hours in the same day.")
  end

   test "user should not be able to make more than the maximum amount of peak hours bookings during a week" do
    user = create(:member)
    court = create(:court_with_defined_opening_and_peak_times, peak_time_from: "17:00", peak_time_to: "19:00")
    create(:booking, user: user, court: court, date_from: Date.today+1, time_from: "17:00")
    create(:booking, user: user, court: court, date_from: Date.today+2, time_from: "17:00")
    booking = build(:booking, user: user, court: court, date_from: Date.today+4, time_from: "18:00")
    refute booking.valid?
    assert booking.errors.full_messages.include?("No more than 2 bookings allowed during peak hours in the same week.")
  end

  test "should not allow duplicate bookings" do
    court = create(:court)
    create(:booking, court: court, date_from: Date.today+1, time_from: "19:00")
    refute build(:booking, court: court, date_from: Date.today+1, time_from: "19:00").valid?
  end

  test "should not be able to destroy a booking after it has started" do
    booking = create(:booking, date_from: Date.today+1, time_from: "19:00")
    stub_dates(Date.today+1, "19:30")
    refute booking.destroy
  end

  test "scope methods should return correct records" do
    courts = create_list(:court, 4)
    booking1 = create(:booking, court: courts.first, date_from: Date.today+1, time_from: "19:00")
    booking2 = create(:booking, court: courts[1], date_from: Date.today+1, time_from: "12:00")
    booking3 = create(:booking, court: courts[1], date_from: Date.today+2, time_from: "20:40")
    booking4 = create(:booking, court: courts[2], date_from: Date.today+1, time_from: "10:00")

    assert_equal 3, Booking.by_day(Date.today+1).count
    assert_equal 2, Booking.by_court(courts[1].id).count
    assert_equal [booking3, booking1, booking2, booking4], Booking.ordered.to_a
  end

  test "#players should return the players who are playing the game" do
    players =  create_list(:user, 2)
    booking1 =  build(:booking, user: players.first, opponent: nil)
    booking2 = build(:booking, user: players.first, opponent: players.last)
    booking3 =  build(:booking, user: nil)

    assert_equal players.first.full_name, booking1.players
    assert_equal "#{players.first.full_name} v #{players.last.full_name}", booking2.players
    assert_nil booking3.players

  end

  test "we should know if the booking is in the past or the future" do
    booking1 =  create(:booking, date_from: Date.today+1, time_from: "17:40")
    booking2 =  create(:booking, date_from: Date.today+1, time_from: "19:40")

    stub_dates(Date.today+1, "19:00")

    assert booking1.in_the_past?
    refute booking1.in_the_future?
    refute booking2.in_the_past?
    assert booking2.in_the_future?

  end

  test "#time_and_place should tell us when and where the booking is" do
    booking = build(:booking, time_from: "17:40", time_to: "19:40")

    assert_equal "Court: #{booking.court.number} on #{booking.date_from.to_s(:uk)} at 5.40pm to 7.40pm", booking.time_and_place
  end

  test "#link_text should provide appropriate text for link" do
    booking = build(:booking, time_from: "19:00")
    assert_equal "#{booking.court.number} - #{booking.date_from.to_s(:uk)} 19:00", booking.link_text
  end

  test "#opponent_name should populate opponent" do
    user = create(:user)
    booking = build(:booking, opponent_name: user.full_name)
    assert_equal user, booking.opponent
    assert_equal user.full_name, booking.opponent_name
  end

  test "date_to should equal date_from" do
    booking = build(:booking)
    assert_equal booking.date_from, booking.date_to
  end

  test "court_ids should return an array of the court id" do
    booking = build(:booking)
    assert_equal [booking.court_id], booking.court_ids
  end

  test "#today should return a list of bookings for today" do
    courts = create_list(:court_with_opening_and_peak_times, 4)
    create(:booking, court: courts.first, date_from: Date.today, time_from: "11:00", time_to: "11:30")
    create(:booking, court: courts[1], date_from: Date.today, time_from: "11:00", time_to: "11:30")
    create(:booking, court: courts[2], date_from: Date.today, time_from: "11:00", time_to: "11:30")
    create(:booking, court: courts.last, date_from: Date.today+1, time_from: "11:00", time_to: "11:30")
    assert_equal 3, Booking.today.count
  end

end