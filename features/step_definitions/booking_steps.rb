Given /^the peak hours are "(.*?)" and "(.*?)"$/ do |start_time, finish_time|
  create_setting "peak_hours_start_time", start_time, "start time of peak hours"
  create_setting "peak_hours_finish_time", finish_time, "finish time of peak hours"
end

Given /^no more than (\d+) courts can be booked during peak times$/ do |number|
  create_setting "max_peak_hours_bookings", "#{number}", "maximum number of courts that can be booked during peak hours"
end

Given /^there is a booking with user id: (\d+) and court number: (\d+) and booking date and time: "(.*?)"$/ do |user_id, court_number, booking_date_and_time|
  create(:booking, user_id: user_id, court_number: court_number, booking_date_and_time: booking_date_and_time)
end

When /^I view the booking with user id: (\d+) and court number: (\d+) and booking date and time: "(.*?)"$/ do |user_id, court_number, booking_date_and_time|
  booking = create(:booking, user_id: user_id, court_number: court_number, booking_date_and_time: booking_date_and_time)
  #visit "/bookings/#{booking.id}"
  step "I go to the bookings/#{booking.id} page"
end