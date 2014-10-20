require "test_helper"

class HashAttributesTest < ActiveSupport::TestCase

  class TestHashAttributes
    include HashAttributes
    hash_attributes :attr_a, :attr_b, :attr_c

    def initialize(attributes)
      set_attributes(attributes)
    end

  private

    def default_attributes
      { attr_a: "a", attr_b: 2}
    end
  end

  class TestHashAttributesWithTime < TestHashAttributes
    def initialize(attributes)
      set_attributes_with_time(attributes)
    end
  end

  test "with arguments passed should create instance variables" do
    obj = TestHashAttributes.new(attr_a: "aaa", attr_b: "bbb", attr_c: "ccc")
    assert_equal "aaa", obj.attr_a
    assert_equal "bbb", obj.attr_b
    assert_equal "ccc", obj.attr_c
  end

  test "without arguments passed should use defaults" do
    obj = TestHashAttributes.new(attr_c: "ccc")
    assert_equal "a", obj.attr_a
    assert_equal 2, obj.attr_b
    assert_equal "ccc", obj.attr_c
  end

  test "with time arguments should be converted to time" do
    obj = TestHashAttributesWithTime.new(attr_a: "10:30", attr_b: "12:30", attr_c: 12)
    assert_instance_of Time, obj.attr_a
    assert_instance_of Time, obj.attr_b
    assert_instance_of Fixnum, obj.attr_c
  end

end