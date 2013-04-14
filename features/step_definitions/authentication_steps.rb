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

