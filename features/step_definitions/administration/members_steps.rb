Before('@members') do
  create_list(:member, 10)
  setup_record_checker :member, :username
end

Then(/^I should see a list of all of the current members$/) do
  page_contains_all_members?
end

When(/^I edit an existing member$/) do
  within("#member_#{member.id}") do
    click_link "Edit"
  end
end

When(/^I update the email address( .*)?$/) do |invalid|
  fill_in "Email", with: (invalid.nil? ? valid_email : invalid_email)
end

When(/^I fill in valid member details$/) do
  fill_in_details valid_user_details
end

When(/^I follow the link to delete an existing member$/) do
  within("#member_#{member.id}") do
    click_link "Delete"
  end
end

When(/^I add some valid permissions$/) do
  within("#permissions") do
    add_user_permissions
  end
end

When(/^I fill in email with an email address$/) do
  fill_in "Email", with: standard_email_address
end

Then(/^the member should have some valid permissions$/) do
  user_should_have_standard_permissions standard_email_address
end

Given(/^there is a member with standard permissions$/) do
  create_current_user create_standard_user
end

When(/^I edit the member$/) do
  within("#member_#{current_user.id}") do
    click_link "Edit"
  end
end

When(/^I remove a permission$/) do
  within("#permissions") do
    remove_permission
  end
end

Then(/^(\d+) permission should have been deleted from the member$/) do |n|
  current_user.permissions.count.should == AllowedAction.count - n.to_i
end