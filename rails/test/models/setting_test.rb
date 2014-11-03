require "test_helper"

class SettingTest < ActiveSupport::TestCase

  test "setting should not be valid without name" do
    refute build(:setting, name: nil).valid?
  end

  test "setting should only be valid with unique name" do
    create(:setting, name: "my_name").valid?
    refute build(:setting, name: "my_name").valid?
  end

  test "setting should not be valid without value" do
    refute build(:setting, value: nil).valid?
  end

  test "setting should not be valid without description" do
    refute build(:setting, description: nil).valid?
  end

  test "name should not allow spaces or special characters" do
    refute build(:setting, name: "my name").valid?
    refute build(:setting, name: "$my_name").valid?
    refute build(:setting, name: "#my_name").valid?
  end

  test "number setting should have the correct type" do
    assert_equal "NumberSetting", build(:number_setting).type
  end

  test "number setting should ensure value is a positive number" do
    refute build(:number_setting, value: "number").valid?
    refute build(:number_setting, value: -1).valid?
  end

  test "time setting should have the correct type" do
    assert_equal "TimeSetting", build(:time_setting).type
  end

  test "time setting should ensure that value is in format hh:mm and is a valid time" do
    refute build(:time_setting, value: "1045").valid?
    refute build(:time_setting, value: "invalid").valid?
    refute build(:time_setting, value: "25:45").valid?
    refute build(:time_setting, value: "10:63").valid?
  end

  test "settings should update application settings constant when a new setting is added or modified" do
    assert_respond_to build(:setting), :reload_constants
  end

end