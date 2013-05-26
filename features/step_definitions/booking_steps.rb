Given /^the peak hours are "(.*?)" and "(.*?)"$/ do |start_time, finish_time|
  create_setting "peak_hours_start_time", start_time, "start time of peak hours"
  create_setting "peak_hours_finish_time", finish_time, "finish time of peak hours"
end

Given /^no more than (\d+) courts can be booked during peak times$/ do |number|
  create_setting "max_peak_hours_bookings", "#{number}", "maximum number of courts that can be booked during peak hours"
end

Given /^there is a booking with (.*?)$/ do |attributes|
  @booking = create(:booking, create_attributes(attributes))
end

When /^I view the booking with (.*?)$/ do |attributes|
  step %Q{there is a booking with #{attributes}}
  step %Q{I go to the bookings/#{@booking.id} page}
end