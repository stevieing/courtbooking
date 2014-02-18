#booking step definitions
Before('@opponent') do
  opponent
end

When /^I select an opponent$/ do
  select opponent.username, from: "Opponent"
end

Given(/^I have already created the maximum number of bookings during peak hours for the week$/) do
  create_current_booking(peak_hours_bookings_for_the_week(courts, current_user, slot_time))
end

Given(/^I have already created the maximum number of bookings during peak hours for the day$/) do
  create_current_booking(peak_hours_bookings_for_the_day(courts, current_user, slot_time))
end

Then /^I should see a message telling me I cannot make another booking during peak hours for the week$/ do
  page.should have_content "No more than #{max_peak_hours_bookings_weekly} bookings allowed during peak hours in the same week."
end

Then(/^I should see a message telling me I cannot make another booking during peak hours for the day$/) do
  page.should have_content "No more than #{max_peak_hours_bookings_daily} booking allowed during peak hours in the same day."
end

Given /^I have created a booking$/ do
  create_current_booking(create_valid_booking(current_user))
end

When /^I view the booking (I|they) have created$/ do |arg1|
  visit booking_path(current_booking.id)
end

When /^I edit the booking (I|they) have created$/ do |arg1|
  visit edit_booking_path(current_booking.id)
end

When /^I delete the booking$/ do
  click_link "Delete Booking"
end

When /^the booking is in the past$/ do
  dates.bookings_in_the_past(dates.in_the_future(7))
end

Given /^a booking has been created by another user$/ do
  create_current_booking(create_valid_booking(opponent))
end

Then /^I should not be able to delete the booking$/ do
  page.should_not have_link("Delete Booking")
end

When(/^I try to create another booking during peak hours$/) do
  visit courts_path(current_booking.playing_on)
  click_link current_booking.link_text
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

Given(/^I have created a number of bookings in the future$/) do
  create_subsequent_bookings(current_user, dates.current_date, booking_slots.all, 4)
end

Then(/^I should( not)? see a list of the bookings (I|they) have created$/) do |negate, who|
   (who == "I" ? current_user : other_member).bookings.each do |booking|
     if negate
       page.should_not have_selector(:id, "booking_" + booking.id.to_s)
     else
       within("#booking_" + booking.id.to_s) { valid_booking_details booking }
     end
   end
 end

Then(/^I should be able to (.*) each booking$/) do |modify|
  current_user.bookings.each do |booking|
    within("#booking_" + booking.id.to_s) do
      page.should have_link modify.capitalize
    end
  end
end

Then(/^I should see my booking$/) do
  valid_booking_details current_booking
end

Then(/^I should not be able to edit the booking$/) do
  page.should_not have_link "Edit Booking"
end

When(/^I follow the link to (.*) the booking$/) do |modify|
  within("#booking_" + current_booking.id.to_s) do
    click_link "#{modify.capitalize} Booking"
  end
end

Then(/^the "(.*?)" field should contain "(.*?)"$/) do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end

Then(/^I should not be able to select myself as an opponent$/) do
  page.should_not have_xpath "//select[@id = 'Opponent']/option[@value = '#{current_user.username}']"
end