Before('@allowedactions') do
  setup_record_checker :allowed_actions, :id
end

When(/^I fill in valid allowed action details$/) do
  add_valid_allowed_action build(:allowed_action_string)
end

Then(/^I should see a list of all of the allowed actions$/) do
  page_contains_all_allowed_actions?
end

Given(/^I have created an allowed action$/) do
  create_allowed_action create(:allowed_action)
end

When(/^I edit the allowed action I have created$/) do
  within("#allowed_action_#{allowed_action.id}") do
    click_link "Edit"
  end
end

When(/^I modify the name$/) do
  modify_allowed_action_name
end

When(/^I delete the allowed action I have created$/) do
  within("#allowed_action_#{allowed_action.id}") do
    click_link "Delete"
  end
end