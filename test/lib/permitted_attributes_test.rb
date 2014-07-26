require "test_helper"

class PermittedAttributesTest < ActiveSupport::TestCase

  def setup
    @permitted_attributes = PermittedAttributes.new(
      File.expand_path(File.join(Rails.root,"test","support","permitted_attributes.yml"))
    )
  end

  test "attributes are created for models" do
    assert_respond_to @permitted_attributes, :model_a
    assert_respond_to @permitted_attributes, :model_b
  end

  test "whitelist attributes exist" do
    assert_equal [:attr_a, :attr_b, :attr_c, {attr_d: []}], @permitted_attributes.model_a.whitelist
  end

  test "nested attributes exist" do
    assert_equal([:attr_d, :attr_e, :attr_f], @permitted_attributes.model_a.nested.model_b)
  end

  test "virtual attributes exist" do
    assert_equal([:attr_g, :attr_h], @permitted_attributes.model_a.virtual)
  end

  test "all attributes are correct" do
    assert_equal(
      [[:attr_a, :attr_b, :attr_c, {attr_d: []}],{:model_b => [:attr_d, :attr_e, :attr_f]}, [:attr_g, :attr_h]],
      @permitted_attributes.model_a.all)
  end

end