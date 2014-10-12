require "test_helper"

class GridTest < ActiveSupport::TestCase

  attr_reader :courts, :slots, :grid

  def setup
    @courts = create_list(:court, 4)
    @slots = Slots::Base.new(slot_first: "06:20", slot_last: "09:00", slot_time: 40)
    @grid = Slots::Grid.new(slots, courts)
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
    assert_equal other.ids.first.last.id, grid.ids.first.last.id
    assert_equal other.ids.count, grid.ids.count
  end

  test "dup should not transfer bookings or activities" do
    stub_settings
    dupped_grid = grid.dup
    activity = create(:event, date_from: Date.today+2, time_from: "07:00", time_to: "08:20", courts: [courts.first, courts.last])
    grid.find("07:00",courts.first.id).fill(Table::Cell::Activity.new(activity, "07:00"))
    assert_equal activity.description, grid.find("07:00",courts.first.id).cell.text
    assert_instance_of Table::Cell::NullCell, dupped_grid.find("07:00",courts.first.id).cell
  end

  test "#find_by_id should return correct slot" do
    first_slot = grid.find("06:20", courts.first.id)
    last_slot = grid.find("09:00", courts.last.id)
    assert_equal first_slot, grid.find_by_id(first_slot.id)
    assert_equal last_slot, grid.find_by_id(last_slot.id)
    assert_nil grid.find_by_id(9999)
  end

  test "#delete_rows! should delete specified rows from grid" do
    slot = Slots::Slot.new("07:40","09:00", @slots.constraints)
    grid.delete_rows!(slot)
    assert_nil grid.find("07:40")
    assert_nil grid.find("08:20")
    refute_nil grid.find("09:00")
  end

  test "unfilled should return array of slots which are empty" do
    grid.unfilled do |empty|
      empty.fill String.new
    end
    assert_instance_of String, grid.find("06:20", courts.first.id).cell
    assert_instance_of String, grid.find("09:00", courts.last.id).cell
  end

end