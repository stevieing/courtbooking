require "test_helper"

class GridTest < ActiveSupport::TestCase

  attr_reader :courts, :court, :constraints, :grid

  def setup
    create_list(:court, 3)
    @court = create(:court_with_defined_opening_and_peak_times, opening_time_from: "06:20", opening_time_to: "08:20")
    @courts = Court.all
    @constraints = Slots::Constraints.new(slot_first: "06:20", slot_last: "09:00", slot_time: 40)
    @grid = Slots::Grid.new(constraints, courts)
  end

  test "new grid should create a row for each slot plus a header and footer" do
    assert_equal 7, grid.table.count
  end

  test "new grid should create a column for each court_id plus a header and footer" do
    assert_equal 6, grid.find("06:20").count
  end

  test "new grid should create a CourtSlot for each court" do
    assert grid.table.all? do |key, row|
      row.all? do |k, cell|
        unless cell.header?
          cell.instance_of? Slots::CourtSlot
        end
      end
    end
  end

  test "header and footer for each row should contain slot time" do
    assert_equal "06:20", grid.find("06:20",:header).text
    assert_equal "06:20", grid.find("06:20",:footer).text
  end

  test "header and footer for rows should contain court number" do
    assert_equal "Court #{courts.first.number}", grid.find(:header,courts.first.id).text
    assert_equal "Court #{courts.last.number}", grid.find(:footer,courts.last.id).text
  end

  test "dup should do a proper dup" do
    other = grid.dup
    other.rows.delete("06:20")
    refute_nil grid.find("06:20", courts.first.id)
  end

  test "dup should not transfer bookings or activities" do
    stub_settings
    dupped_grid = grid.dup
    activity = create(:event, date_from: Date.today+2, time_from: "07:00", time_to: "08:20", courts: [courts.first, courts.last])
    grid.fill("07:00",courts.first.id,Table::Cell::Activity.new(activity, "07:00"))
    assert_equal activity.description, grid.find("07:00",courts.first.id).text
    assert_equal :empty, dupped_grid.find("07:00",courts.first.id).type
  end

  test "#find_by_id should return correct slot" do
    first_slot = grid.find("06:20", courts.first.id).slot
    last_slot = grid.find("09:00", courts.last.id).slot
    assert_equal first_slot, grid.find_by_id(first_slot.id)
    assert_equal last_slot, grid.find_by_id(last_slot.id)
    assert_nil grid.find_by_id(9999)
  end

  test "#remove_slots! should delete specified rows from grid" do
    slot = Slots::Slot.new(from: "07:40", to: "09:00", constraints: constraints)
    grid.remove_slots!(slot.series.all)
    assert_nil grid.find("07:40")
    assert_nil grid.find("08:20")
    assert_nil grid.find("09:00")
  end

  test "close_court_slots should close the correct slots" do
    stub_settings
    grid.close_court_slots!(Date.today.cwday-1)
    assert grid.find("06:20", courts.first.id).closed?
    assert grid.find("09:00", courts.first.id).closed?
    refute grid.find("06:20", court.id).closed?
    assert grid.find("09:00", court.id).closed?
  end

  test "add_bookings! should add bookings to correct slots" do
    stub_settings
    member = create(:member)
    booking1 = create(:booking, user: member, date_from: Date.today+1, time_from: "06:20", time_to: "07:00", court: court)
    booking2 = create(:booking, user: member, date_from: Date.today+1, time_from: "08:20", time_to: "09:00", court: court)
    booking3 = build(:booking, date_from: Date.today+1, time_from: "07:00", time_to: "09:00", court: court)
    bookings = Booking.all
    grid.add_bookings!(bookings, member, Date.today+1)
    assert_equal "booking", grid.find("06:20", court.id).html_class
    assert_equal "booking", grid.find("08:20", court.id).html_class
    assert_equal "free", grid.find("07:00", court.id).html_class
  end

  test "add_activities! should add activities to correct slots" do
    stub_settings
    closure = create(:closure, date_from: Date.today+1, date_to: Date.today+4, time_from: "06:20", time_to: "07:00", courts: [courts.first])
    event = create(:event, date_from: Date.today+1, time_from: "07:40", time_to: "08:20", courts: [court])
    grid.add_activities!(Activity.all)
    assert_equal :activity, grid.find("06:20", courts.first.id).type
    assert_equal :activity, grid.find("07:40", court.id).type
  end

  test "add_class_to_rows_in_past should add html class past to all rows when date is before today" do
    grid.add_class_to_rows_in_past(Date.today-1)
    assert_equal "past", grid.find("06:20").html_class
    assert_equal "past", grid.find("09:00").html_class
  end

  test "add_class_to_rows_in_past should add no class to all rows when date is after today" do
    grid.add_class_to_rows_in_past(Date.today+1)
    assert_nil grid.find("06:20").html_class
    assert_nil grid.find("09:00").html_class
  end

  test "add_class_to_rows_in_past should add class to correct rows when date is today" do
    Time.stubs(:now).returns(Time.parse("07:40"))
    grid.add_class_to_rows_in_past(Date.today)
    assert_equal "past", grid.find("06:20").html_class
    assert_nil grid.find("09:00").html_class
  end


end