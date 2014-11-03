require "test_helper"

class BaseTest < ActiveSupport::TestCase

  test "blank table should have rows and headings" do
    table = Table::Base.new
    assert_instance_of Hash, table.rows
    assert_equal "", table.heading
  end

  test "we should be able to add a sensible heading" do
    assert_equal "heading", Table::Base.new(heading: "heading").heading
  end

  test "we should be able to add some rows" do
    assert_equal 2, Table::Base.new(rows: {a: Table::Row.new, b: Table::Row.new}).rows.count
  end

  test "#add should add a new row" do
    table = Table::Base.new
    table.add(:a, Table::Row.new)
    assert_instance_of Table::Row, table.rows[:a]
  end

  test "we should be able to add stuff to the table via a block in the initializer" do
    table = Table::Base.new do |table|
      table.heading = "heading"
      table.add :a, Table::Row.new
    end
    assert_instance_of Table::Row, table.rows[:a]
    assert_equal "heading", table.heading

  end

  test "#find should find the correct row or column" do
    row = Table::Row.new do |row|
      row.add :b, Table::Cell::Text.new(text: "this is a cell")
    end

    table = Table::Base.new do |table|
      table.add :a, row
    end

    assert_equal row, table.find(:a)
    assert_nil table.find(:b)
    assert_equal "this is a cell", table.find(:a,:b).text
    assert_nil table.find(:a,:c)
    assert_nil table.find(:b,:c)

  end

  test "#without_heading should not include rows with headers or footers" do
     table = Table::Base.new do |table|
      table.add :header, Table::Row.new(header: true)
      table.add :a, Table::Row.new
      table.add :footer, Table::Row.new(header: true)
    end

    i = 0
    table.without_headers { |row| i += 1 }
    assert_equal 1, i

  end

end