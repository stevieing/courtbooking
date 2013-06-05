Before('@admin') do
  create_current_user(create_user("joebloggs", true))
end

Given /^I am signed in as (.*)$/ do |type|
  sign_in current_user
end