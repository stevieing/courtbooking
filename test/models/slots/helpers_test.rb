require "test_helper"

class ParentClass
  class ChildClass
  end
end


class HelpersTest < ActiveSupport::TestCase

  include Slots::Helpers

  test "#to_time should convert hh:mm to time" do
    assert_instance_of Time, to_time("10:30")
  end

  test "#to_time should not convert anything other than hh:mm" do
    assert_equal 10, to_time(10)
    assert_instance_of Fixnum, to_time(10)
    assert_instance_of Time, Time.parse("10:30")
    assert_nil to_time(nil)
  end

  test "#to_range should convert slots to a range" do
    assert_equal ["06:00","06:30","07:00","07:30","08:00"], to_range("06:00","08:00",30)
  end

  test "new class methods should return class name without namspace or as a symbol" do

    my_class = ParentClass.new

    assert_equal :parent_class, my_class.class_to_sym

    my_class = ParentClass::ChildClass.new
    assert_instance_of ParentClass::ChildClass, my_class
    assert_equal :child_class, my_class.class_to_sym
  end

end