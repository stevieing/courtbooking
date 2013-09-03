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