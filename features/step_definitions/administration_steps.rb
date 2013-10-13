Before('@users') do
  create_list(:user, 10)
end

When(/^I click on the "(.*?)" link$/) do |link|
  click_link link
end

Then(/^I should see a field for each setting$/) do
  page_contains_all_settings?
end

When(/^I update one of the settings( .*)?$/) do |invalid|
  within("#setting_#{setting.id}") do
    fill_in setting.description, with: (invalid.nil? ? valid_setting_value(setting) : invalid_setting_value(setting))
    click_button "Update"
  end
end

Then(/^I should see a message that the setting has been updated$/) do
  page.should have_content "#{setting.description} successfully updated"
end

Then(/^I should see a message that the setting has not been updated$/) do
  page.should have_content "#{setting.description} has an invalid value"
end

Then(/^I should see a list of all of the current users$/) do
  page_contains_all_users?
end

When(/^I edit an existing user$/) do
  within("#user_#{user.id}") do
    click_link "Edit"
  end
end

When(/^I update the email address( .*)?$/) do |invalid|
  fill_in "Email", with: (invalid.nil? ? valid_email : invalid_email)
  click_button "Submit user"
end

When(/^I follow the link to add a new user$/) do
  click_link "Add new user"
end

When(/^I fill in valid user details$/) do
  user = build(:user)
  fill_in_details({username: user.username, email: user.email, password: user.password, password_confirmation: user.password})
end

When(/^I leave the (.*) blank$/) do |field|
  fill_in field, with: nil
end

When(/^I follow the link to delete an existing user$/) do
  within("#user_#{user.id}") do
    click_link "Delete"
  end
end
