Given(/^the following list of members exist:$/) do |table|
  table.raw.each do |row|
    create(:member, full_name: row[0])
  end
end

When /^I wait for (\d+) seconds?$/ do |secs|
  sleep secs.to_i
end

Then /^I should see the following autocomplete options:$/ do |table|
  table.raw.each do |row|
    find(:xpath, "//a[text()='#{row[0]}']")
  end
end

When(/^I follow "(.*?)"$/) do |link_text|
   execute_script %Q{ $('.ui-menu-item a:contains("#{link_text}")').trigger("mouseenter").click(); }
end

Then(/^the field "(.*?)" should have the value "(.*?)"$/) do |field, value|
  find_field(field).value.should eq(value)
end

Then(/^I fill in "(.*?)" with some gobbledyegook$/) do |field|
  fill_in field, with: "weiofhjwioehfwweofhw"
end

When(/^I book a court for sometime tomorrow$/) do
  click_link (Date.today+1).day_of_month
  create_current_booking(first_available_booking(Date.today+1))
  click_link current_booking.link_text
end