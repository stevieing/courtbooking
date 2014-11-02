require "test_helper"
require File.expand_path(Rails.root.join('test','fakes','fake_setting.rb'))


class AppSettingsTest < ActiveSupport::TestCase

  def setup
    AppSettings.setup do |config|
      config.const_name = "FakeSettings"
      config.model_name = "FakeSetting"
    end
    AppSettings.load!
  end

  def teardown
    AppSettings.reset!
  end

  test "create settings should create constant" do
    FakeSetting.create(name: :my_name, value: "my value")
    assert FakeSettings.respond_to?(:my_name)
    assert_equal "my value", FakeSettings.my_name
  end

  test "create settings with a number should convert setting to integer" do
    FakeSetting.create(name: :my_number, value: "999")
    assert FakeSettings.respond_to?(:my_number)
    assert_instance_of Fixnum, FakeSettings.my_number
  end

  test "create settings with a time should convert setting to a time" do
    FakeSetting.create(name: :my_time, value: "22:30")
    assert FakeSettings.respond_to?(:my_time)
    assert_instance_of Time, FakeSettings.my_time
  end

  test "updating setting should update constant" do
    FakeSetting.create(name: :my_name, value: "my value")
    assert_equal "my value", FakeSettings.my_name
    FakeSetting.first.update_attributes(value: "new value")
    assert_equal "new value", FakeSettings.my_name
  end

  test "reset! should reset constant and table names" do
    AppSettings.reset!
    refute_equal "FakeSettings", AppSettings.const_name
    refute_equal "FakeSetting", AppSettings.model_name
  end

  test "const should return constant" do
    assert_equal FakeSettings, AppSettings.const
  end

end