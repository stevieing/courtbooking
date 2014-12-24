require "test_helper"
require File.expand_path(Rails.root.join('test','fakes','basic_model.rb'))

class BasicFormTest < ActiveSupport::TestCase

  class BasicModelForm
    include BasicForm
    set_model BasicModel, [:attr_a, :attr_b, :attr_c]
    validate :verify_basic_model
    def initialize(object=nil)
      build(object) do
        basic_model.attr_a = "a"
      end
    end
    def save_objects
      run_transaction do
        basic_model.save
      end
    end
    def submit(params)
      push_and_save(params.merge(attr_a: "aaa"))
    end
    def verify_basic_model
      check_for_errors basic_model
    end
  end

  class PasswordChecker
    include BasicForm
  end

  def setup
    @basic_model_form = BasicModelForm.new
  end

  test "should respond to attributes" do
    assert_respond_to @basic_model_form, :attr_a
    assert_respond_to @basic_model_form, :attr_b
    assert_respond_to @basic_model_form, :attr_c
  end

  test "should have the correct model name" do
    assert_equal "BasicModel", BasicModelForm.model_name
  end

  test "should have a basic_model" do
    assert_instance_of BasicModel, @basic_model_form.basic_model
  end

  test "should run initializer block" do
    assert_equal "a", @basic_model_form.attr_a
  end

  test "submitting valid parameters should create a new record" do
    @basic_model_form.submit({ attr_a: "a", attr_b: "b", attr_c: 1}.with_indifferent_access)
    assert @basic_model_form.valid?
    assert_equal 1, BasicModel.count
  end

  test "submitting invalid parameters should not create a new record" do
    @basic_model_form.submit({ attr_a: "a", attr_b: "b", attr_c: "c"}.with_indifferent_access)
    refute @basic_model_form.valid?
    assert_equal 0, BasicModel.count
  end

  test "submit with a modifier should modify record" do
    @basic_model_form.submit({ attr_a: "a", attr_b: "b", attr_c: "c"}.with_indifferent_access)
    assert_equal "aaa", @basic_model_form.attr_a
  end

  test "new with object should be created correctly" do
    #TODO: move this to a factory
    @basic_model = BasicModel.create(attr_a: "a", attr_b: "b", attr_c: 1)
    @basic_model_form = BasicModelForm.new(@basic_model)
    assert_equal @basic_model, @basic_model_form.basic_model
  end

  test "existing object should be persisted" do
    @basic_model = BasicModel.create(attr_a: "a", attr_b: "b", attr_c: 1)
    @basic_model_form = BasicModelForm.new(@basic_model)
    assert_equal @basic_model.id, @basic_model_form.id
    assert @basic_model_form.persisted?
  end

  test "updated object with correct attributes should be submitted correctly" do
    @basic_model = BasicModel.create(attr_a: "a", attr_b: "b", attr_c: 1)
    @basic_model_form = BasicModelForm.new(@basic_model)
    @basic_model_form.submit({ attr_a: "a", attr_b: "b", attr_c: 2}.with_indifferent_access)
    assert_equal 2, @basic_model.attr_c
  end

  test "should convert value to boolean" do
    assert @basic_model_form.to_boolean("1")
  end

  test "password should be processed correctly" do
    @password_checker = PasswordChecker.new
    assert_equal ({password: "password", password_confirmation: "password"}),
      @password_checker.process_password({password: "password", password_confirmation: "password"})
    assert_equal ({password: "password", password_confirmation: ""}),
      @password_checker.process_password({password: "password", password_confirmation: ""})
    assert_equal ({password: "", password_confirmation: "password"}),
      @password_checker.process_password({password: "", password_confirmation: "password"})
    assert_equal ({}),
      @password_checker.process_password({password: "", password_confirmation: ""})
  end

end