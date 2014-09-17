require "test_helper"

class RowTest < ActiveSupport::TestCase

  attr_reader :cells

  def setup
    @cells = {a: "1", b: "2", c: "3"}
  end

  test "row with no attributes should be empty" do
    row = Slots::Row.new
    assert row.empty?
    assert_nil row.html_class
  end

  test "row with attributes should not be empty" do
    row = Slots::Row.new(cells: @cells, html_class: "classy")
    assert 3, row.count
    assert_equal "classy", row.html_class
  end

  test "row with block should add cells" do
    row = Slots::Row.new do |row|
      cells.each do |k,v|
        row.add k,v
      end
    end
    assert_equal 3, row.count
  end

  test "find should return correct slot" do
    row = Slots::Row.new(cells)
    assert cells[:a], row.find(:a)
  end

end