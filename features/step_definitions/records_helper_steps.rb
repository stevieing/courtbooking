When(/^I use the RecordsHelper module$/) do
  setup_record_checker :member, :username
end

Then(/^I should be able to check for a list of all the current members$/) do
  page_contains_all_members?
end