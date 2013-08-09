When(/^I have successfully created a new booking( against an opponent)?$/) do |enemy|
  visit courts_path
  create_current_booking(build_valid_booking)
  click_link current_booking.link_text
  select(opponent.username, :from => "Opponent") unless enemy.nil?
  click_button "Submit Booking"
  page.should have_content "Booking successfully created"
end

Then(/^I should see an appropriate message in the subject$/) do
  current_email.should have_subject("Booking Confirmation - Stamford Squash Club")
end

Then(/^I should see the date, time and court number for the booking in the email body$/) do
  current_email.default_part_body.to_s.should include("Court #{current_booking.court_number}")
  current_email.default_part_body.to_s.should include(current_booking.time_and_place_text)
end

Then(/^my opponent should receive an email$/) do
  unread_emails_for(opponent.email).size.should == 1
end

Then(/^there should be a link to edit the booking in the email body$/) do
  current_email.default_part_body.to_s.should have_link("Edit booking")
end