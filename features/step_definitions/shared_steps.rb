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
  page.should have_content arg1
end

Then /^I should( not)? see a link to "(.*?)"$/ do |negate, arg1|
  negate ? page.should_not(have_link(arg1)) : page.should(have_link(arg1))
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in field, with: value
end

Then /^I should be on (.+)$/ do |page_name|
  current_path.should == path_to(page_name)
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
  page.should have_content message
end