require "test_helper"

class ClosuresTest < ActiveSupport::TestCase

  attr_reader :courts, :date

  def setup
    @courts = create_list(:court, 4)
    @date = Date.today+1
    closure1 = create(:closure, date_from: Date.today, date_to: Date.today+5, courts: @courts)
    closure2 = create(:closure, date_from: Date.today+1, date_to: Date.today+3, courts: @courts)

    closure3 = create(:closure, date_from: Date.today, date_to: Date.today+4, courts: [@courts.first, @courts.last])
    closure4 = create(:closure, date_from: Date.today+1, date_to: Date.today+3, courts: [@courts.first, @courts.last])

    closure5 = create(:closure, date_from: Date.today+2, date_to: Date.today+5, courts: [@courts.first, @courts.last])

  end

  test "closures should return the correct closures for that day" do
    assert_equal 2, Courts::Closures.new(courts, date).count
  end

  test "closures for_all_courts should return the correct closures for that day" do
    assert_equal 2, Courts::Closures.new(courts, date).for_all_courts.count
  end

end