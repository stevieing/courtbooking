Given /^there are (\d+) courts$/ do |n|
  1.upto(n.to_i) do |i|
    create(:court, number: i)
  end
end

Then /^I should see a column for each court$/ do
  Court.all.each do |court|
    page.should have_content "Court " + court.number.to_s
  end
end

Given /^the courts are available from "(.*?)" to "(.*?)" with a (\d+) minute time slot$/ do |start_time, finish_time, slot_time|
  @timeslots = build(:time_slots, start_time: start_time, finish_time: finish_time, slot_time: slot_time)
end

Then /^I should see a row for each time slot$/ do
  @timeslots.slots.each do |slot|
    page.should have_content slot.strftime("%H:%M")
  end
end