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

When(/^I add a valid (.*) time$/) do |type|
   within("##{type}times") do
    add_valid_court_time 1, type
  end  
end

Then(/^the court should have (\w+) times$/) do |type|
  has_valid_court_times new_court_number, "#{type}_times".to_s
end

When(/^I add an additional (.*) time$/) do |type|
  within("##{type}times") do
    click_link "Add #{type.capitalize} Time"
    add_valid_court_time 2, type
  end
end

Then(/^the court should have (\d+) (.*) times?$/) do |n, type|
  has_multiple_court_times new_court_number, n, "#{type}_times".to_sym
end

When(/^I remove the additional (.*) time$/) do |type|
  within("##{type}times") do
    remove_court_time 2, type
  end
end