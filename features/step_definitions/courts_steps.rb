Before('@other_member') do
  other_member
end

Given /^there are (\d+) courts$/ do |number|
  create_courts number.to_i
end

Then /^I should see todays date$/ do
  page.should have_content(dates.current_date_to_s)
end

When /^I view the courts for tomorrow$/ do
  dates.set_current_date(1)
  click_link dates.current_date.day_of_month
end

When /^I view the courts for (\d+) days? from today$/ do |days|
  dates.set_current_date(days.to_i)
  click_link dates.current_date.day_of_month
end

Then /^I should see a box for each day until a set day in the future$/ do
  within_the_calendar_container do
    dates.current_date.to(days_bookings_can_be_made_in_advance).each do |date|
      page.should have_content(date.day_of_month)
    end
  end
end

Then /^I should be able to select each day apart from today$/ do
  within_the_calendar_container do
    dates.current_date.to(days_bookings_can_be_made_in_advance).each do |date|
      date == dates.current_date ? (page.should_not have_link(date.day_of_month)) : (page.should have_link(date.day_of_month))
    end
  end
end

Then /^I should not be able to view the courts beyond that date$/ do
  within_the_calendar_container do
    page.should_not have_link((dates.current_date + days_bookings_can_be_made_in_advance + 2).day_of_month)
  end
end

Then /^I should not be able to view the courts before today$/ do
  within_the_calendar_container do
    page.should_not have_link((dates.current_date - 1).day_of_month)
  end
end

Then /^the calendar should have an appropriate heading$/ do
  within_the_calendar_container do
    page.should have_content(dates.current_date.calendar_header(dates.current_date + days_bookings_can_be_made_in_advance))
  end
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

Then /^I should be able to edit my bookings$/ do
  within_the_bookingslots_container do
    edit_bookings? current_user
  end
end

Then /^I should not be able to edit the bookings for another member$/ do
  within_the_bookingslots_container do
    edit_bookings? other_member, false
  end
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