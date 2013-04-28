Given /^a user exists with username: '(\w+)'$/ do |username|
  user = create(:user, username: username)
end

When /^I login with the correct credentials$/ do
  fill_in 'Username', with: 'joebloggs'
  fill_in 'Password', with: 'password'
  click_button 'sign in'
end

Given /^a guest user$/ do
end

Given /^I am logged in$/ do
  step "a user exists with username: 'joebloggs'"
  step "I go to the sign_in page"
  step "I login with the correct credentials"
end

Given /^the courts are setup$/ do
  step "there are 4 courts"
  step "the courts are available from \"06:40\" to \"22:00\" with a 40 minute time slot"
  step "the courts can be booked up to 3 weeks in advance"
  step "todays date is \"01 September 2013\""
end

