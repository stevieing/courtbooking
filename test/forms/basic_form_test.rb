require "test_helper"

class BasicFormTest < ActiveSupport::TestCase

  class TestModelForm
    include BasicForm
    set_model :test_model, [:attr_a, :attr_b, :attr_c]
  end

  def setup
    @test_model_form = TestModelForm.new
  end

  test "should respond to attributes" do
    assert_respond_to @test_model_form, :attr_a
    assert_respond_to @test_model_form, :attr_b
    assert_respond_to @test_model_form, :attr_c
  end

  test "should have the correct model name" do
    assert_equal "TestModel", TestModelForm.model_name
  end

  test "should have a test_model" do
    assert_instance_of TestModel, @test_model_form.test_model
  end

end