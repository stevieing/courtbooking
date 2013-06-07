Before('@other_member') do
  other_member
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
  page.should have_content(current_date.to_s(:uk))
end

Then /^I should see a row for each time slot$/ do
  within_the_bookingslots_container do
    time_slots.slots.each do |slot|
      page.should have_content(slot)
    end
  end
end

When /^I view the courts for tomorrow$/ do
  click_link day_of_month(create_current_date(current_date + 1))
end

When /^I view the courts for (\d+) days from today$/ do |arg1|
  click_link day_of_month(create_current_date(current_date + arg1.to_i))
end

Then /^I should be able to book each time slot for each court for today$/ do
  within_the_bookingslots_container do
    courts.each do |court|
      time_slots.slots.each do |slot|
        page.should have_link("#{court.number.to_s} - #{current_date.to_s(:uk)} #{slot}")
      end
    end
  end
end

Then /^I should see a box for each day until a set day in the future$/ do
  within_the_calendar_container do
    days_in_calendar(current_date, days_bookings_can_be_made_in_advance).each do |date|
      page.should have_content(day_of_month(date))
    end
  end
end

Then /^I should be able to select each day apart from today$/ do
  within_the_calendar_container do
    days_in_calendar(current_date, days_bookings_can_be_made_in_advance).each do |date|
      date == current_date ? (page.should_not have_link(day_of_month(date))) : (page.should have_link(day_of_month(date)))
    end
  end
end

Then /^I should not be able to view the courts beyond that date$/ do
  within_the_calendar_container do
    page.should_not have_link(day_of_month(current_date + days_bookings_can_be_made_in_advance + 2))
  end
end

Then /^I should not be able to view the courts before today$/ do
  within_the_calendar_container do
    page.should_not have_link(day_of_month(current_date - 1))
  end
end

Then /^the calendar should have an appropriate heading$/ do
  within_the_calendar_container do
    page.should have_content(current_date.calendar_header(current_date + days_bookings_can_be_made_in_advance))
  end
end

Then /^I should see the correct date$/ do
  page.should have_content(current_date.to_s(:uk))
end


Then /^I should be redirected to the courts page for that day$/ do
  current_path.should == courts_path(current_date)
end

Given /^todays date is near the end of the month$/ do
  date = Date.today.end_of_month
  Date.stub(:today).and_return(date)
end

Given /^there are a number of valid bookings for myself and another member for the next day$/ do
  create_valid_bookings([current_user, other_member], opponent, courts, current_date+1, time_slots.slots)
end

Then /^I should be able to edit my bookings$/ do
  within_the_bookingslots_container do
    edit_my_bookings? current_user
  end
end

Then /^I should not be able to edit the bookings for another member$/ do
  within_the_bookingslots_container do
    edit_others_bookings? other_member
  end
end

When /^there are two bookings one after the other for tomorrow$/ do
  create_current_bookings(create_subsequent_bookings(current_user, current_date, time_slots.slots))
end

When /^it is tomorrow after the first booking has started$/ do
  set_system_date_and_datetime(current_bookings.first.playing_on, current_bookings.first.playing_on_text + " " + current_bookings.first.playing_from)
end

Then /^I should not be able to edit the first booking$/ do
  page.should have_content(current_bookings.first.players)
end

Then /^I should be able to edit the second booking$/ do
  page.should have_link(current_bookings.last.players)
end

When /^I follow a link to create a new booking$/ do
  click_link valid_booking_link
end

Then /^I should see valid booking details$/ do
  page.should have_content valid_time_and_place_text
end