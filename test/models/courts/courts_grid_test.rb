require "test_helper"

class CourtsGridTest < ActiveSupport::TestCase

  attr_reader :options, :courts, :grid

  def setup
    create_settings_constant
    @options = {slot_first: "06:20", slot_last: "09:00", slot_time: 40}
    @courts = create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "06:20", opening_time_to: "08:20")
    @grid = Slots::Grid.new(options.merge(courts: @courts))
    Settings.stubs(:slots).returns(grid)
  end

  test "new courts grid should have correct heading" do
    courts_grid = Courts::Grid.new(Date.today+1, build(:guest), grid)
    assert_equal (Date.today+1).to_s(:uk), courts_grid.table.heading
  end

  test "new courts grid should have correct closure message" do
    closure = create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "06:20", time_to: "07:00", courts: @courts)
    courts_grid = Courts::Grid.new(Date.today+1, build(:guest), grid)
    assert_equal closure.message, courts_grid.closure_message
  end

  test "new courts grid should populate cells" do
    courts_grid = Courts::Grid.new(Date.today+1, build(:guest), @grid.dup)
    assert_equal :booking, courts_grid.table.find("06:20", courts.first.id).type
    assert_equal :closed, courts_grid.table.find("09:00", courts.last.id).type
  end

  test "new courts grid should have correct html class" do
    courts_grid = Courts::Grid.new(Date.today+1, build(:guest), grid)
    assert_equal "grid", courts_grid.html_class
  end

  test "#to_json should return root grid, plus closure message and table.to_json" do
    closure = create(:closure, date_from: Date.today+1, date_to: Date.today+5, time_from: "06:20", time_to: "07:00", courts: @courts)
    courts_grid = Courts::Grid.new(Date.today+1, build(:guest), grid)
    assert_equal "{\"courts_grid\":{\"closure_message\":\"#{closure.message}\",\"table\":#{courts_grid.table.to_json}}}", courts_grid.to_json
  end

end