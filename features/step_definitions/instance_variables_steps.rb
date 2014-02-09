Given /^there is a configuration value for days bookings can be made in advance$/ do
  Settings.days_bookings_can_be_made_in_advance.should_not be_nil
end

When /^I set up days that bookings can be made in advance through a helper method$/ do
  setup_instance_variable :days_bookings_can_be_made_in_advance do
    Settings.days_bookings_can_be_made_in_advance
  end
end

Then /^it should return the correct value$/ do
  days_bookings_can_be_made_in_advance.should == Settings.days_bookings_can_be_made_in_advance
end

Given /^there is a helper class for date utils$/ do
end

When /^I set up a date utils instance$/ do
  @dates = DateTimeHelpers::Utils.new(Date.today.to_s(:uk), "19:00")
end

When /^I set up the helper method$/ do
  setup_instance_variable :dates do
    DateTimeHelpers::Utils.new(Date.today.to_s(:uk), "19:00")
  end
end

Then /^it should contain the correct values$/ do
  dates.current_date.should == Date.today
end

Given /^there is a current booking instance variable$/ do
  @this_booking_id = current_booking.id
end

When /^I change the value of the booking instance variable$/ do
  create_current_booking(create(:booking, playing_on: (Date.today+5).to_s(:uk)))
  @that_booking_id = current_booking.id
end

Then /^the booking should be the one I just added$/ do
  @this_booking_id.should_not == @that_booking_id
end