Before('@managecourts') do
  setup_record_checker :courts, :number
end

Before('@nextcourtnumber') do
  new_court_number
end

Then(/^I should see a list of all of the courts$/) do
  page_contains_all_courts?
end

When(/^I fill in the Court number with an invalid value$/) do
  fill_in "Court number", with: courts.last.number
end

When(/^I fill in time from with an invalid value for the (.*)$/) do |court_time|
  add_invalid_court_time court_time.gsub(/ /,'').pluralize
end

When(/^I fill in the Court number with a valid value$/) do
  fill_in "Court number", with: new_court_number
end

When(/^I add a valid opening time$/) do
  add_valid_opening_time
end

Then(/^the court should have opening times$/) do
  has_valid_opening_times new_court_number
end

When(/^I add a valid peak time$/) do
  add_valid_peak_time
end

Then(/^the court should have peak times$/) do
  has_valid_peak_times new_court_number
end
