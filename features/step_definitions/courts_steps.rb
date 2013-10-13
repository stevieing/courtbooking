Before('@other_member') do
  other_member
end

Before('@split_opening_times') do
  create_court_opening_type(:court_with_split_opening_times)
end

Given /^there are (\d+) courts$/ do |number|
  create_courts number.to_i
end

Then /^I should see a column for each court$/ do
  within_the_bookingslots_container do
    courts.each { |court| page.should have_content("Court #{court.number}") }
  end
end

Then /^I should see todays date$/ do
  page.should have_content(dates.current_date_to_s)
end

Then /^I should see a row for each time slot$/ do
  within_the_bookingslots_container do
    slots.all.each do |slot|
      page.should have_content(slot)
    end
  end
end

When /^I view the courts for tomorrow$/ do
  dates.set_current_date(1)
  click_link dates.current_date.day_of_month
end

When /^I view the courts for (\d+) days from today$/ do |days|
  dates.set_current_date(days.to_i)
  click_link dates.current_date.day_of_month
end

Then /^I should be able to book each time slot for each court for today$/ do
  within_the_bookingslots_container do
    courts.each do |court|
      slots.all.each do |slot|
        page.should have_link("#{court.number.to_s} - #{dates.current_date_to_s} #{slot}")
      end
    end
  end
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

Given /^there are a number of valid bookings for myself and another member for the next day$/ do
  create_valid_bookings([current_user, other_member], opponent, courts, dates.current_date+1, slots.all)
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
  create_current_bookings(create_subsequent_bookings(current_user, dates.current_date, slots.all))
end

When /^it is tomorrow after the first booking has started$/ do
  set_dates(current_bookings.first.playing_on_text, current_bookings.first.playing_from)
end

Then /^I should not be able to edit the first booking$/ do
  page.should have_content(current_bookings.first.players)
end

Then /^I should be able to edit the second booking$/ do
  page.should have_link(current_bookings.last.players)
end

When /^I follow a link to create a new booking$/ do
  create_current_booking(build_valid_booking)
  click_link current_booking.link_text
end

Then /^I should see valid booking details$/ do
  page.should have_content valid_time_and_place_text(current_booking)
end

When(/^I follow a link to edit the booking$/) do
  click_link current_booking.players
end

Then(/^I should not see a row for time slots where all the courts are closed$/) do
  Court.all.count.should == 4
  within_the_bookingslots_container do
    courts.each do |court|
      slots.all.each do |slot|
         page.should_not have_content(slot) if Court.closed?(dates.current_date.wday, slot)
      end
    end
  end
end