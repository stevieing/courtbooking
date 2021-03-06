require "test_helper"

class RowTest < ActiveSupport::TestCase

  attr_reader :cells

  def setup
    @cells = {a: "1", b: "2", c: "3"}
  end

  test "row with no attributes should be empty" do
    row = Table::Row.new
    assert row.empty?
    assert_nil row.html_class
    refute row.header?
  end

  test "row with attributes should not be empty" do
    row = Table::Row.new(cells: @cells, html_class: "classy", header: true)
    assert 3, row.count
    assert_equal "classy", row.html_class
    assert row.header?
  end

  test "row with block should add cells" do
    row = Table::Row.new do |row|
      row.header = true
      cells.each do |k,v|
        row.add k,Table::Cell::Text.new(text: v)
      end
    end
    assert_equal 3, row.count
  end

  test "find should return correct slot" do
    row = Table::Row.new(cells)
    assert cells[:a], row.find(:a)
  end

  test "#dup should dup properly" do
    cell = Table::Cell::Text.new(text: "a")
    row = Table::Row.new do |row|
      row.add :a, cell
    end
    dupped_row = row.dup
    refute_equal row.find(:a), dupped_row.find(:a)
  end

  test "#build_header should build a header row from the appropriate objects" do
    Header = Struct.new(:id, :heading)
    headers = [Header.new(1,"a"), Header.new(2,"b"), Header.new(3,"c"), Header.new(4, "d")]
    row = Table::Row.build_header(headers)
    assert_instance_of Table::Row, row
    assert_equal 4, row.count
    assert row.header?
    assert_equal "a", row.find(1).text
    assert row.find(1).header?
    assert_equal "d", row.find(4).text
  end

  test "#empty_cells should return array of empty cells" do
    row = Table::Row.new do |row|
      row.add :a, Table::Cell::Empty.new
      row.add :b, Table::Cell::Text.new(text: "b")
      row.add :c, Table::Cell::Empty.new
    end

    assert_instance_of Array, row.empty_cells
    assert_equal 2, row.empty_cells.length
  end

end