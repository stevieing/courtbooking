When(/^I use the RecordsHelper module$/) do
  setup_record_checker :user, :username
end

Then(/^I should be able to check for a list of all the current users$/) do
  page_contains_all_users?
end