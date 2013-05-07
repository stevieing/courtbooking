Given /^an? (\w+) user exists with (.*?)$/ do |user_type, attributes|
  factory_attributes = create_attributes(attributes)
  factory_attributes["admin"] = true if user_type == "admin"
  user = create(:user, factory_attributes)
end

Given /^a user exists with (.*?)$/ do |attributes|
  step "a standard user exists with #{attributes}"
end

Given /^a guest user$/ do
end

When /^I login as "(.*?)" with password "(.*?)"$/ do |username, password|
  step "I go to the sign_in page"
  step "I fill in \"Username\" with \"#{username}\""
  step "I fill in \"Password\" with \"#{password}\""
  step "I click the \"sign in\" button"
end

Given /^the courts are setup$/ do
  step "there are 4 courts"
  step "the courts are available from \"06:40\" to \"22:00\" with a 40 minute time slot"
  step "the courts can be booked up to 3 weeks in advance"
  step "todays date is \"01 September 2013\""
end
