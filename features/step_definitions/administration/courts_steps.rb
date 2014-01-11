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

When(/^I add a valid opening time$/) do
  within("#openingtimes") do
    add_valid_opening_time(1)
  end
end

Then(/^the court should have opening times$/) do
  has_valid_opening_times new_court_number
end

When(/^I add a valid peak time$/) do
  within("#peaktimes") do
    add_valid_peak_time(1)
  end
end

Then(/^the court should have peak times$/) do
  has_valid_peak_times new_court_number
end

When(/^I add an additional opening time$/) do
  # within("#openingtimes") do
  #     click_link "Add Opening Time"
  #     add_valid_opening_time(2)
  #   end
  pending # express the regexp above with the code you wish you had
end

Then(/^the court should have more than one opening time$/) do
  pending # express the regexp above with the code you wish you had
end
