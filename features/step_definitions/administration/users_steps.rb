Before('@users') do
  create_list(:user, 10)
  setup_record_checker :user, :username
end

Then(/^I should see a list of all of the current users$/) do
  page_contains_all_users?
end

When(/^I edit an existing user$/) do
  within("#user_#{user.id}") do
    click_link "Edit"
  end
end

When(/^I update the email address( .*)?$/) do |invalid|
  fill_in "Email", with: (invalid.nil? ? valid_email : invalid_email)
  click_button "Submit user"
end

When(/^I fill in valid user details$/) do
  fill_in_details valid_user_details
end

When(/^I follow the link to delete an existing user$/) do
  within("#user_#{user.id}") do
    click_link "Delete"
  end
end