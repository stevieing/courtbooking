Given /^there are (\d+) courts$/ do |n|
  1.upto(n.to_i) do |i|
    create(:court, number: i)
  end
end

Then /^I should see a column for each court$/ do
  within_the_bookingslots_container do
    Court.all.each do |court|
      step %Q{I should see "Court #{court.number.to_s}"}
    end
  end
end

Given /^the courts are available from "(.*?)" to "(.*?)" with a (\d+) minute time slot$/ do |start_time, finish_time, slot_time|
  @timeslots = create(:time_slot, start_time: start_time, finish_time: finish_time, slot_time: slot_time)
end

Given /^the courts can be booked up to (\d+) (days|weeks) in advance$/ do |arg1,arg2|
  create_setting "days_that_can_be_booked_in_advance", days_or_weeks(arg1, arg2).to_s, description: "Number of days that courts can be booked in advance"
end

Then /^I should see a row for each time slot$/ do
  @timeslots.slots.each do |slot|
    step %Q{I should see "#{slot.strftime("%H:%M")}"}
  end
end

Then /^I should see a time slot for each court$/ do
  within_the_bookingslots_container do
    Court.all.each do |court|
      @timeslots.slots.each do |slot|
        step %Q{I should see "#{court.number.to_s} - #{slot.strftime("%H:%M")}"}
      end
    end
  end
end

Then /^I should see a link to book each time slot for each court for "(.*?)"$/ do |date| 
  within_the_bookingslots_container do
    Court.all.each do |court|
      @timeslots.slots.each do |slot|
        step %Q{I should see a link to "#{court.number.to_s} - #{date} #{slot.strftime("%H:%M")}"}
      end
    end
  end
end

Then /^I should see a box for date "(.*?)"$/ do |arg1|
  within_the_calendar_container do
    step %Q{I should see the day of month for date #{arg1}}
    step %Q{I should see the day of week for date #{arg1}}
  end
end

Then /^I should see a box for each day for the next (\d+) (days|weeks)$/ do |arg1, arg2|
  within_the_calendar_container do
    (Date.today+1).upto((Date.today+1) + (days_or_weeks(arg1,arg2)-1)) do |date|
      step %Q{I should see the day of month for date #{date}}
      step %Q{I should see the day of week for date #{date}}
      step %Q{I should see a link to "#{date.strftime('%d')}"}
    end
  end
end

Then /^I should see the day of month for (date .*?)$/ do |date|
  step %Q{I should see "#{date.strftime('%d')}"}
end

Then /^I should see the day of week for (date .*?)$/ do |date|
  step %Q{I should see "#{date.strftime('%a')}"}
end

Then /^I should see a header with "(.*?)"$/ do |header|
  within_the_calendar_container do
    step %Q{I should see "#{header}"}
  end
end

Then /^I should (not)? see a link which is (\d+) days (before|after) today$/ do |negate, days, pre_or_post|
  within_the_calendar_container do
    date = (pre_or_post == "after" ? Date.today + days.to_i : Date.today - days.to_i)
    if negate
      step %Q{I should not see a link to "#{date.strftime('%d')}"}
    else
      step %Q{I should see a link to "#{date.strftime('%d')}"}
    end
  end
end

Then /^I should be redirected to the courts page with (date ".*?")$/ do |date|
  step %Q{I should be redirected to the courts/#{date.strftime('%F')} page}
end

Then /^I should not see a link to "(.*?)" on the calendar$/ do |arg1|
  within_the_calendar_container do
    step %Q{I should not see a link to "#{arg1}"}
  end
end

Then /^I click the "(.*?)" link on the calendar$/ do |arg1|
  within_the_calendar_container do
    step %Q{I click the "#{arg1}" link}
  end
end

Then /^I should see "(.*?)" within the bookings$/ do |arg1|
  within_the_bookingslots_container do
    step %Q{I should see "#{arg1}"}
  end
end

Then /^I should see a link to "(.*?)" within the bookings$/ do |link|
  within_the_bookingslots_container do
    step %Q{I should see a link to "#{link}"}
  end
end

Then /^I should not see a link to "(.*?)" within the bookings$/ do |link|
  within_the_bookingslots_container do
    step %Q{I should not see a link to "#{link}"}
  end
end

def within_the_bookingslots_container(&block)
  within('#bookingslots', &block)
end

def within_the_calendar_container(&block)
  within('#calendar', &block)
end