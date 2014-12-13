require "test_helper"

class GridProcessor < ActiveSupport::TestCase

  attr_reader :courts, :constraints, :grid, :grid_processor

  def setup
    stub_settings
    @options = {slot_first: "06:20", slot_last: "09:00", slot_time: 40}
    @courts = create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "06:20", opening_time_to: "08:20")
    @constraints = Slots::Constraints.new(slot_first: "06:20", slot_last: "09:00", slot_time: 40)
    Settings.slots.stubs(:constraints).returns(constraints)
    @grid = Slots::Grid.new(constraints, courts)
  end

  test "closures for all courts should remove correct rows and create message" do
    closure = create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "06:20", time_to: "07:00", courts: courts)
    @grid_processor = Courts::GridProcessor.new(Date.today+1, build(:guest), grid)
    grid_processor.run!
    assert_equal closure.message, grid_processor.closure_message
    assert_nil grid.find("06:20")
    refute_nil grid.find("07:00")
  end

  test "closures should be added to grid" do
    closure1 = create(:closure, date_from: Date.today+1, date_to: Date.today+4, time_from: "06:20", time_to: "08:20", courts: [courts.first])
    closure2 = create(:closure, date_from: Date.today+1, date_to: Date.today+3, time_from: "08:20", time_to: "09:00", courts: [courts.last])
    @grid_processor = Courts::GridProcessor.new(Date.today+1, build(:guest), grid)
    grid_processor.run!
    assert_equal :activity, grid.find("06:20", courts.first.id).type
    assert_equal closure1.description, grid.find("06:20", courts.first.id).text
    assert_equal :activity, grid.find("08:20", courts.last.id).type
    assert_equal closure2.description, grid.find("08:20", courts.last.id).text
  end

   test "events should be added to grid" do
    event1 = create(:event, date_from: Date.today+1, time_from: "06:20", time_to: "08:20", courts: [courts.first])
    event2 = create(:event, date_from: Date.today+1, time_from: "08:20", time_to: "09:00",courts: [courts.last])
    @grid_processor = Courts::GridProcessor.new(Date.today+1, build(:guest), grid)
    grid_processor.run!
    assert_equal :activity, grid.find("06:20", courts.first.id).type
    assert_equal event1.description, grid.find("06:20", courts.first.id).text
    assert_equal :activity, grid.find("08:20", courts.last.id).type
    assert_equal event1.description, grid.find("08:20", courts.last.id).text
  end

  test "bookings should be added to grid" do
    member = create(:member)
    booking1 = create(:booking, user: member, date_from: Date.today+1, time_from: "06:20", time_to: "07:00", court: courts.first)
    booking2 = create(:booking, user: member, date_from: Date.today+1, time_from: "07:40", time_to: "08:20", court: courts.last)
    @grid_processor = Courts::GridProcessor.new(Date.today+1, member, grid)
    grid_processor.run!
    assert_equal :booking, grid.find("06:20", courts.first.id).type
    assert_equal booking1.players, grid.find("06:20", courts.first.id).text
    assert_equal :booking, grid.find("08:20", courts.last.id).type
  end

  test "all empty cells should be filled with new bookings" do
    member = create(:member)
    booking = build(:booking, date_from: Date.today+1, time_from: "07:00", time_to: "07:40", court: courts.first)
    @grid_processor = Courts::GridProcessor.new(Date.today+1, member, grid)
    grid_processor.run!
    assert_equal :booking, grid.find("07:00", courts.first.id).type
    assert_equal :booking, grid.find("07:40", courts[2].id).type
    assert_equal :booking, grid.find("07:40", courts.last.id).type
    assert grid.find("07:00", courts.first.id).link?
    assert_equal booking.link_text, grid.find("07:00", courts.first.id).text
  end

  test "if the court is closed slot should be closed" do
    @grid_processor = Courts::GridProcessor.new(Date.today+1, build(:guest), grid)
    grid_processor.run!
    assert grid.find("09:00", courts.last.id).closed?
    assert grid.find("09:00", courts.first.id).closed?
  end

  test "class should be added to rows that are in the past" do
    Time.stubs(:now).returns(Time.parse("08:00"))
    @grid_processor = Courts::GridProcessor.new(Date.today, build(:guest), grid)
    grid_processor.run!
    assert_nil grid.find("09:00").html_class
    assert_equal "past", grid.find("07:40").html_class
  end

end