Before do
  setup_instance_variables
end

Given /^PENDING/ do
  pending
end

When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^I should see "(.*?)"$/ do |arg1|
  expect(page).to have_content(arg1)
end

Then /^I should( not)? see a link to "(.*?)"$/ do |negate, arg1|
  negate ? page.should_not(have_link(arg1)) : page.should(have_link(arg1))
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in field, with: value
end

Then /^I should be on (.+)$/ do |page_name|
  expect(current_path).to eq(path_to(page_name))
end

Then /^I should be redirected to the (.*) page$/ do |page_name|
  step %{I should be on the #{page_name} page}
end

Given /^todays date is "(.*?)" and the time is "(.*?)"$/ do |date, time|
  set_dates(date, time)
end

When /^I submit the (.*)$/ do |model|
  click_button "Submit #{model}"
end

Then(/^I should see a message with the text (.*)$/) do |message|
  expect(page).to have_content(message)
end

When(/^I click on the "(.*?)" link$/) do |link|
  click_link link
end

When(/^I follow the link to add a new (.*)$/) do |model|
  click_link "Add new #{model}"
end

When(/^I leave the (.*) blank$/) do |field|
  fill_in field, with: nil
end