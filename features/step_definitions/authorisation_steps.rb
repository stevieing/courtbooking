Given /^I am logged in as a (\w+) user$/ do |user_type|
  step %Q{a #{user_type} user exists with username: "joe bloggs" and password: "password"}
  step %Q{I login as "joe bloggs" with password "password"}
end