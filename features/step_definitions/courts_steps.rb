Before('@other_member') do
  other_member
end

When /^I view the courts for (\d+) days? from today$/ do |days|
  set_dates((dates.current_date+days.to_i).to_s(:uk), "19:00")
  click_link dates.current_date.day_of_month
end

Then /^I should see the correct date$/ do
  page.should have_content(dates.current_date_to_s)
end


Then /^I should be redirected to the courts page for that day$/ do
  current_path.should == courts_path(dates.current_date)
end

Given /^todays date is near the end of the month$/ do
  dates.end_of_month
end

When /^there are two bookings one after the other for tomorrow$/ do
  create_current_bookings(create_subsequent_bookings(current_user, dates.current_date, booking_slots.all))
end

When /^it is tomorrow after the first booking has started$/ do
  set_dates(current_bookings.first.playing_on_text, current_bookings.first.time_from)
end

Then /^I should not be able to edit the first booking$/ do
  page.should have_content(current_bookings.first.players)
end

Then /^I should be able to edit the second booking$/ do
  page.should have_link(current_bookings.last.players)
end

Given(/^All of the courts are closed for a fixed period$/) do
  create_current_closure create_valid_closure(:all, valid_closure_details)
end

Then(/^I should see a message telling me when and why the courts are closed$/) do
  page.should have_content(current_closure.message)
end

Given(/^All of the courts are closed for a fixed period for (\d+) days$/) do |n|
  create_current_closure create_valid_closure(:all, valid_closure_details(n.to_i))
end