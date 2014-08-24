require "test_helper.rb"

class ConstraintsTest < ActiveSupport::TestCase

  def setup
    @constraints = Slots::Constraints.new(
      slot_first: "06:00", slot_last: "17:00", slot_time: 30)
  end

  test "should be valid with valid attributes" do
    assert @constraints.valid?
  end

  test "constraints should cover correct slots" do
    refute @constraints.cover? "05:00"
    assert @constraints.cover? "06:00"
    assert @constraints.cover? "12:00"
    assert @constraints.cover? "17:00"
    refute @constraints.cover? "18:00"
  end

  test "constraints should cover the correct slots whatever the day" do
    Time.stubs(:now).returns((Date.today-2.days).to_time)
    refute @constraints.cover? "05:00"
    assert @constraints.cover? "06:00"
    assert @constraints.cover? "12:00"
    assert @constraints.cover? "17:00"
    refute @constraints.cover? "18:00"
  end

end