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

   test "#without_heading should not include cells with headers or footers" do
     row = Table::Row.new do |row|
      row.add :header, Table::Cell::Text.new(header: true)
      row.add :a, Table::Cell::Text.new(text: "a")
      row.add :footer, Table::Cell::Text.new(header: true)
    end

    i = 0
    row.without_headers { |cell| i += 1 }
    assert_equal 1, i

  end

end