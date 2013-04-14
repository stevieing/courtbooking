Given /^an? (\w+) User exists with username: '(\w+)'$/ do |user_type, username|
  user = create(:user, username: username, admin: (user_type == "admin"))
end

Given /^I am logged in as (an?) (\w+) User$/ do |arg1, arg2|
  step "#{arg1} #{arg2} User exists with username: 'joebloggs'"
  step "I go to the sign_in page"
  step "I login with the correct credentials"
end