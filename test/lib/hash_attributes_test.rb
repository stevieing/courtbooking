require "test_helper"

class HashAttributesTest < ActiveSupport::TestCase

  class TestHashAttributes
    include HashAttributes
    hash_attributes attr_a: "a", attr_b: 2, attr_c: {}

    def initialize(attributes = {})
      set_attributes(attributes)
    end

    def add(k, v)
      attr_c[k] = v
    end

  end

  class TestHashAttributesWithTime < TestHashAttributes
    def initialize(attributes)
      set_attributes_with_time(attributes)
    end
  end

  test "default attributes should be correct types and values" do
    obj = TestHashAttributes.new
    assert_instance_of Hash, obj.default_attributes
    assert_equal 3, obj.default_attributes.count
  end

  test "with arguments passed should create instance variables" do
    obj = TestHashAttributes.new(attr_a: "aaa", attr_b: "bbb", attr_c: "ccc")
    assert_equal "aaa", obj.attr_a
    assert_equal "bbb", obj.attr_b
    assert_equal "ccc", obj.attr_c
  end

  test "without arguments passed should use defaults" do
    obj = TestHashAttributes.new
    assert_equal "a", obj.attr_a
    assert_equal 2, obj.attr_b
    assert_instance_of Hash, obj.attr_c
    assert_empty obj.attr_c
  end

  test "with time arguments should be converted to time" do
    obj = TestHashAttributesWithTime.new(attr_a: "10:30", attr_b: "12:30", attr_c: 12)
    assert_instance_of Time, obj.attr_a
    assert_instance_of Time, obj.attr_b
    assert_instance_of Fixnum, obj.attr_c
  end

  test "any attributes that are objects should not be shared ie dupped properly" do
    obj_a = TestHashAttributes.new
    obj_b = TestHashAttributes.new
    obj_a.add(:a, "a")
    assert obj_a.attr_c.has_key?(:a)
    refute obj_b.attr_c.has_key?(:a)
  end

end