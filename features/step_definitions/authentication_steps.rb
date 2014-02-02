Given /^I am not signed in$/ do
end

When /^I sign in with the correct credentials$/ do
  sign_in current_user
end

Given /^I am signed in$/ do
  sign_in current_user
end

Then /^I should( not)? be able to sign (in|out|up)$/ do |negate, in_or_out|
  text = "SIGN #{in_or_out.upcase}"
  negate ? page.should_not(have_link(text)) : page.should(have_link(text))
end

Then /^I should see my Full name$/ do
  page.should have_content "Signed in as: #{current_user.full_name}"
end

When /^I press the sign in button$/ do
  click_button "sign in"
end

Then /^I should see an error message explaining that my username or password are wrong$/ do
  page.should have_content "Incorrect username or password"
end

Given /^the courts are setup$/ do
  setup_courts
end

When /^I sign out$/ do
  click_link "SIGN OUT"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully"
end
