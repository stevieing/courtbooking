Given(/^I follow the link to closures$/) do
  click_link "closures"
end

When(/^I fill in valid closure details$/) do
  add_valid_activity_details build(:closure)
end

When(/^I fill in valid event details$/) do
  add_valid_activity_details build(:event)
end

When(/^I add a list of courts (.*)$/) do |arg1|
  add_list_of_courts
end

Given(/^I have created a court (closure|event)$/) do |activity|
  create_activity_and_count activity
end

When(/^I edit the (closure|event) I have created$/) do |activity|
   within("##{activity}_#{current_activity.id}") do
    click_link "Edit"
  end
end

When(/^I remove a court$/) do
  within("#courts") do
  	uncheck current_activity.courts.last.number
  end
end

Then(/^the (closure|event) should have (\d+) less court$/) do |activity, n|
  current_activity.courts.count.should == current_count - n.to_i
end

When(/^I remove all of the courts$/) do
	within("#courts") do
  	remove_all_courts_from_activity current_activity
  end
end

When(/^I delete the (closure|event) I have created$/) do |activity|
  within("##{activity}_#{current_activity.id}") do
   	click_link "Delete"
  end
end