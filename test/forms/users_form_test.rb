require "test_helper"

class UsersFormTest < ActiveSupport::TestCase

  def setup
    create_list(:allowed_action, 4)
    @users_form = UsersForm.new
  end

  test "User should be created with valid attributes" do
    @users_form.submit(attributes_for(:user))
    assert @users_form.valid?
    assert_equal 1, User.count
  end

  test "User should not be created with invalid attributes" do
    @users_form.submit(attributes_for(:user).merge(email: ""))
    refute @users_form.valid?
    assert_empty User.all
  end

  test "User should be updated with valid attributes" do
    @users_form = UsersForm.new(create(:user))
    @users_form.submit(attributes_for(:user).merge(username: "newusername"))
    assert @users_form.valid?
    assert_equal "newusername", @users_form.username
    assert_equal 1, User.count
  end

  test "User should be updated with blank password" do
    @users_form = UsersForm.new(create(:user))
    @users_form.submit(attributes_for(:user).merge(password: "", password_confirmation: ""))
    assert @users_form.valid?
    assert_equal 1, User.count
  end

end