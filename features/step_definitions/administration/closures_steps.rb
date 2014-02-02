Given(/^I follow the link to closures$/) do
  click_link "closures"
end

When(/^I fill in valid closure details$/) do
  add_valid_closure_details valid_closure_details
end

When(/^I add a list of courts to be closed$/) do
  add_list_of_courts valid_closure_details
end

Given(/^I have created a court closure$/) do
  create_current_closure create(:closure)
  create_current_count current_closure.courts.count
end

When(/^I edit the closure I have created$/) do
  within("#closure_#{current_closure.id}") do
   	click_link "Edit"
  end
end

When(/^I remove a court$/) do
  within("#courts") do
  	uncheck current_closure.courts.last.number
  end
end

Then(/^the closure should have (\d+) less court$/) do |n|
  current_closure.courts.count.should == current_count - n.to_i
end

When(/^I remove all of the courts$/) do
	within("#courts") do
  	remove_all_courts_from_closure current_closure
  end
end

When(/^I delete the closure I have created$/) do
  within("#closure_#{current_closure.id}") do
   	click_link "Delete"
  end
end