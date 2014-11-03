Before('@authorisation') do
  create_standard_permissions
end

Before('@admin') do
  create_current_user(create_user("joebloggs", true))
end

Before('@member') do
  create_current_user(create_user("joebloggs"))
end

Before('@adminpermissions') do
  add_admin_permissions(current_user)
end

Given /^I am signed in as (.*)$/ do |type|
  sign_in current_user
end

Then(/^I should not be authorised$/) do
  page.should have_content "Not authorised"
end

Given(/^I have permission to (.*)$/) do |permission|
  add_user_permission(permission)
end