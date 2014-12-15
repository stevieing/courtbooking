require "test_helper"

class ContainerTest < ActiveSupport::TestCase

  class Beaker
    include Table::Container
  end

  attr_reader :beaker

  def setup
    @beaker = Beaker.new do |b|
      b.add :header, Table::Cell::Text.new(header: true)
      b.add :a, Table::Cell::Text.new(text: "a")
      b.add :footer, Table::Cell::Text.new(header: true)
    end
  end

  test "should add cells correctly" do
    assert_equal 3, beaker.count
  end

  test "should be able to find cell correctly" do
    assert_equal "a", beaker.find(:a).text
  end

  test "#dup should dup properly" do
    dupped = beaker.dup
    dupped.fill(:a, Table::Cell::Text.new(text: "a"))
    assert_equal "a", beaker.find(:a).text
    refute_equal "b", dupped.find(:a).text
  end

  test "#without_heading should not include cells with headers or footers" do
    i = 0
    beaker.without_headers { |key, cell| i += 1 }
    assert_equal 1, i
  end

  test "#top_and_tail should add two extra cells either side of current cells with appropriate keys" do
    beaker = Beaker.new do |b|
      b.add :a, Table::Cell::Text.new(text: "a")
    end

    assert_equal 1, beaker.count

    beaker.top_and_tail(Table::Cell::Text.new(text: "heading"))
    assert_equal 3, beaker.count
    assert_equal "heading", beaker.find(:header).text
    assert_equal "heading", beaker.find(:footer).text
  end

  test "#top should add cells to the start of the current cells with an appropriate key" do
    beaker = Beaker.new do |b|
      b.add :a, Table::Cell::Text.new(text: "a")
    end

    assert_equal 1, beaker.count
    beaker.top(Table::Cell::Text.new(text: "heading"))
    assert_equal 2, beaker.count
    assert_equal "heading", beaker.find(:header).text
    assert_equal "heading", beaker.first.text

  end

  test "#tail should add cells to the start of the current cells with an appropriate key" do
    beaker = Beaker.new do |b|
      b.add :a, Table::Cell::Text.new(text: "a")
    end

    assert_equal 1, beaker.count
    beaker.tail(Table::Cell::Text.new(text: "footing"))
    assert_equal 2, beaker.count
    assert_equal "footing", beaker.find(:footer).text
    assert_equal "footing", beaker.last.text

  end

  test "#to_json should return array of cells" do
    assert_equal "{\"cells\":[#{beaker.find(:header).to_json},#{beaker.find(:a).to_json},#{beaker.find(:footer).to_json}]}", beaker.to_json
  end

end