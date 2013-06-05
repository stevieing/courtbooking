Before('@opponent') do
  opponent
end

When /^I fill in valid booking details$/ do
  fill_in "Court Number", with: courts.first.number.to_s
  fill_in "Playing at", with: valid_playing_at
end

When /^I submit the booking$/ do
  click_button "Submit Booking"
end

Then /^I should see a message that the booking has been made$/ do
  page.should have_content "Booking successfully created"
end

When /^I select an opponent$/ do
  select(opponent.username, :from => "Opponent")
end

When /^I should not be able to select myself$/ do
  within("#booking_opponent_user_id") do
    page.should_not have_content current_user.username
  end
end

When /^I try to book a date in the past$/ do
  fill_in "Playing at", with: date_in_the_past(2)
end

Then /^I should see a message telling me the booking must be in the future$/ do
  page.should have_content "Playing at must be after #{DateTime.now.to_s(:booking)}"
end

When /^I try to book a date too far into the future$/ do
  fill_in "Playing at", with: date_in_the_future(days_bookings_can_be_made_in_advance+2)
end

Then /^I should see a message telling me the booking is too far into the future$/ do
  page.should have_content "Playing at must be before #{(DateTime.now+days_bookings_can_be_made_in_advance).to_s(:booking)}"
end

Given /^I have already created the maximum number of bookings during peak hours$/ do
  create_current_booking(peak_hours_bookings(courts, current_user, time_slots.slot_time))
end

When /^I fill in the booking details$/ do
  fill_in "Court Number", with: current_booking.court_number
  fill_in "Playing at", with: current_booking.playing_at_text
end

When /^I try to book a date during peak hours$/ do
end

When /^I use the details for a booking that has already been created$/ do
end

Then /^I should see a message telling me I cannot make another booking during peak hours$/ do
  page.should have_content "No more than #{max_peak_hours_bookings} bookings are allowed during peak hours in the same week."
end

Given /^I have created a booking$/ do
  create_current_booking(create_valid_booking(current_user))
end

Then /^I should see a message telling me I cannot create a duplicate booking$/ do
  page.should have_content "A booking already exists for #{current_booking.playing_at_text} on court #{current_booking.court_number}"
end

When /^I view the booking (I|they) have created$/ do |arg1|
  visit booking_path(current_booking.id)
end

When /^I delete the booking$/ do
  click_link "Delete Booking"
end

Then /^I should see a message telling me the booking has been deleted$/ do
  page.should have_content "Booking successfully deleted"
end

Then /^I should see a message telling me the booking cannot be deleted$/ do
  page.should have_content "Unable to delete booking"
end

When /^I edit the booking I have created$/ do
  visit edit_booking_path(current_booking.id)
end

Then /^I should see a message telling me the booking has been updated$/ do
  page.should have_content "Booking successfully updated"
end

When /^I change playing at$/ do
  fill_in "Playing at", with: date_in_the_future(5)
end

Then /^I should see a message telling me (.*) cannot be changed$/ do |field|
  page.should have_content "#{field} cannot be changed"
end

When /^I change the court number$/ do
  fill_in "Court Number", with: courts.last.number
end

When /^the booking is in the past$/ do
  DateTime.stub(:now).and_return(DateTime.parse(date_in_the_future(7)))
end

Given /^a booking has been created by another user$/ do
  create_current_booking(create_valid_booking(opponent))
end

Then /^I should not be able to delete the booking$/ do
  page.should_not have_link("Delete Booking")
end

Given /^(\d+) bookings can be made during peak hours between "(.*?)" and "(.*?)"$/ do |number, start_time, finish_time|
  peak_hours_settings({max_peak_hours_bookings: number, peak_hours_start_time: start_time, peak_hours_finish_time: finish_time})
end

Given /^the peak hours setting are in place$/ do
  peak_hours_settings
end

Given /^the courts are setup and the peak hours settings are in place$/ do
  setup_courts
  peak_hours_settings
end