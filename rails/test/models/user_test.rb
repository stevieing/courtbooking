require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "a new user should not be able to register without administrator permissions" do
    refute User.devise_modules.include?(:registerable)
  end

  test "a user should not be valid without a username" do
    refute build(:user, username: nil).valid?
  end

  test "a user should not be valid without a password" do
    refute build(:user, password: nil).valid?
  end

  test "a user should not be valid without a email" do
    refute build(:user, email: nil).valid?
  end

  test "a user should not be valid without a full_name" do
    refute build(:user, full_name: nil).valid?
  end

  test "username should be unique" do
    create(:user, username: "uniqueuser")
    refute build(:user, username: "uniqueuser").valid?
  end

  test "user should be able to specify whether they receive emails" do
    assert build(:user, mail_me: true).mail_me?
  end

  test "#without_user should exclude user from relation" do
    users = create_list(:user, 3)
    refute User.without_user(users.first).include?(users.first)
  end

  test "#by_term should allow for searching for users by partial words and should be case insensitive" do
    user1 = create(:user, full_name: "lucy lucy")
    user2 = create(:user, full_name: "lucille")
    user3 = create(:user, full_name: "henrietta")
    assert_equal 2, User.by_term("lu").count
    assert_equal 1, User.by_term("h").count
    assert_empty User.by_term("dx")
    assert_equal 2, User.by_term("Lu").count
  end

  test "#from_terms_except_user should allow for searching for users excluding specific users" do
    user1 = create(:user, full_name: "lucy lucy")
    user2 = create(:user, full_name: "lucille")
    user3 = create(:user, full_name: "henrietta")
    user4 = create(:user, full_name: "lucifer")
    refute User.names_from_term_except_user(user4, "lu").include?("lucifer")
  end

  test "we should be able to create two users with the same email address" do
    create(:user, email: "joebloggs@example.com")
    assert build(:user, email: "joebloggs@example.com").valid?
  end

  test "#ordered should order users correctly" do
    user1 = create(:user, username: "suzann")
    user2 = create(:user, username: "delia")
    user3 = create(:user, username: "dahlia")
    assert_equal user3, User.ordered.first
    assert_equal user2, User.ordered[1]
    assert_equal user1, User.ordered.last
  end

  test "guest user should respond to all_bookings with an empty relation" do
    assert_instance_of Booking::ActiveRecord_Relation, Guest.new.all_bookings
    assert_empty Guest.new.all_bookings
  end

  test "an admin user should have the correct type" do
    assert_equal "Admin", build(:admin).type
  end

  test "an admin user should have access to all bookings" do
    stub_settings
    user = create(:admin)
    create(:booking, date_from: Date.today+1)
    create(:booking, date_from: Date.today+2)
    create(:booking, date_from: Date.today+3, user: user)
    assert_equal 3, user.all_bookings.count
  end

  test "a member should have the correct type" do
    assert_equal "Member", build(:member).type
  end

  test "a member with standard permissions should only be allowed to edit their own bookings" do
    stub_settings
    user = create(:member)
    add_permissions [:bookings_edit], user
    create(:booking, date_from: Date.today+1)
    create(:booking, date_from: Date.today+2, user: user)
    assert_equal 1, user.all_bookings.count
  end

  test "a member with admin permissions should be allowed to edit all of the bookings" do
    stub_settings
    user = create(:member)
    add_permissions [:edit_all_bookings], user
    create(:booking, date_from: Date.today+1)
    create(:booking, date_from: Date.today+2, user: user)
    assert_equal 2, user.all_bookings.count
  end

end