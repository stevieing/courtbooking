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

When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in arg1, with: arg2
end

When /^I click the "(.*?)" button$/ do |button|
  click_button button
end

Then /^I should be on (.+)$/ do |page_name|
  current_path.should == path_to(page_name)
end

Then /^I should be redirected to the (.*) page$/ do |page_name|
  step %{I should be on the #{page_name} page}
end

When /^I click the "(.*?)" link$/ do |link|
  click_link link
end

Then /^there should be a hidden field within (\w+) called "(.*?)" with value "(.*?)"$/ do |model, field, value|
  find(:xpath, "//input[@id='" + model + "_" + field + "']").value.should eql(value)
end

Given /^todays date is "(.*?)" and the time is "(.*?)"$/ do |date, time|
  set_system_date_and_datetime(date, date + " " + time)
  #Date.stub(:today).and_return(Date.parse(date))
  #DateTime.stub(:now).and_return(DateTime.parse(date + " " + time))
end


