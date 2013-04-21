Before ('@create_court_variables') do
  create(:time_slot)
  step "the courts can be booked up to 3 weeks in advance"
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

Then /^I should not see "(.*?)"$/ do |arg1|
  page.should_not have_content arg1
end

Then /^I should( not)? see a link to "(.*?)"$/ do |negate, arg1|
  negate ? page.should_not(have_link(arg1)) : page.should(have_link(arg1))
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in arg1, with: arg2
end

When /^I click the "(.*?)" button$/ do |arg1|
  click_button arg1
end

Then /^I should be on (.+)$/ do |page_name|
  current_path.should == path_to(page_name)
end

Then /^I should be redirected to the (.*) page$/ do |page_name|
  step "I should be on the #{page_name} page"
end

When /^I click the "(.*?)" link$/ do |arg1|
  click_link arg1
end

