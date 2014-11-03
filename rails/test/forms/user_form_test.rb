require "test_helper"

class UserFormTest < ActiveSupport::TestCase

  def setup
    create_list(:allowed_action, 4)
    @user_form = UserForm.new
  end

  test "User should be created with valid attributes" do
    @user_form.submit(attributes_for(:user))
    assert @user_form.valid?
    assert_equal 1, User.count
  end

  test "User should not be created with invalid attributes" do
    @user_form.submit(attributes_for(:user).merge(email: ""))
    refute @user_form.valid?
    assert_empty User.all
  end

  test "User should be updated with valid attributes" do
    @user_form = UserForm.new(create(:user))
    @user_form.submit(attributes_for(:user).merge(username: "newusername"))
    assert @user_form.valid?
    assert_equal "newusername", @user_form.username
    assert_equal 1, User.count
  end

  test "User should be updated with blank password" do
    @user_form = UserForm.new(create(:user))
    @user_form.submit(attributes_for(:user).merge(password: "", password_confirmation: ""))
    assert @user_form.valid?
    assert_equal 1, User.count
  end

end