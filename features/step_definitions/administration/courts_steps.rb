Before('@managecourts') do
  setup_record_checker :courts, :number
end

Before('@nextcourtnumber') do
  new_court_number
end

Then(/^I should see a list of all of the courts$/) do
  page_contains_all_courts?
end

When(/^I fill in the Court number with an? (valid|invalid) value$/) do |valid|
  fill_in "Court number", with: (valid == "valid" ? new_court_number : courts.last.number)
end

When(/^I fill in time from with an invalid value for the (.*)$/) do |court_time|
  add_invalid_court_time court_time.gsub(/ /,'').pluralize
end

When(/^I add (\d+) valid (.*) times?$/) do |n, type|
   within("##{type}times") do
    add_court_time n, type, booking_slots.constraints.first.from, booking_slots.constraints.last.from
  end
end

When(/^I add (\d+) invalid (.*) time$/) do |n, type|
  within("##{type}times") do
    add_court_time n, type, booking_slots.constraints.last.from, booking_slots.constraints.first.to
  end
end

Then(/^the court should have (\w+) times$/) do |type|
  has_valid_court_times new_court_number, "#{type}_times".to_s
end

Then(/^the court should have (\d+) (.*) times?$/) do |n, type|
  has_multiple_court_times new_court_number, n, "#{type}_times".to_sym
end

When(/^I remove the additional (.*) time$/) do |type|
  within("##{type}times") do
    remove_court_time 2, type
  end
end

Given(/^There is a court with a number of (.*) times$/) do |type|
  create_current_count current_court.send("#{type}_times").count
end

Then(/^(\d+) (.*) time should have been deleted from the court$/) do |n, type|
  current_court.send("#{type}_times").count.should == current_count - n.to_i
end

When(/^I (.*) an existing court$/) do |action|
  within("#court_#{current_court.id}") do
    click_link action.capitalize
  end
end

When(/^I remove an? (.*) time$/) do |type|
  within("##{type}times") do
    remove_court_time 1, type
  end
end