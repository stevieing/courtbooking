require "test_helper"

class MembersFormTest < ActiveSupport::TestCase

  def setup
    create_list(:allowed_action, 4)
    @members_form = MembersForm.new
  end

  test "Member should be created with valid attributes" do
    @members_form.submit(attributes_for(:member).merge(allowed_action_ids: AllowedAction.pluck(:id)))
    assert @members_form.valid?
    assert_equal 1, Member.count
  end

  test "Member should not be created with invalid attributes" do
    @members_form.submit(attributes_for(:member).merge(email: ""))
    refute @members_form.valid?
    assert_empty Member.all
  end

  test "Member should be updated with valid attributes" do
    @members_form = MembersForm.new(create(:member))
    @members_form.submit(attributes_for(:member).merge(allowed_action_ids: AllowedAction.pluck(:id).drop(1)))
    assert @members_form.valid?
    assert_equal 1, Member.count
  end

  test "Member should be updated with blank password" do
    @members_form = MembersForm.new(create(:member))
    @members_form.submit(attributes_for(:member).merge(password: "", password_confirmation: ""))
    assert @members_form.valid?
    assert_equal 1, Member.count
  end


  test "#include_action?" do
    @members_form = MembersForm.new(create(:member, allowed_actions: AllowedAction.all))
    assert @members_form.include_action?(AllowedAction.first)
  end

end