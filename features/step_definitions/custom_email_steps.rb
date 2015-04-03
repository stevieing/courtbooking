Before('@user_no_mail') do
  current_user.update_attributes(mail_me: false)
end

When(/^I have successfully created a new booking( against an opponent)?$/) do |enemy|
  create_current_booking(build_valid_booking)
  visit courts_path
  click_link current_booking.link_text
  fill_in "Opponent", with: opponent.full_name unless enemy.nil?
  click_button "Submit booking"
  page.should have_content "Booking successfully created"
end

Then(/^I should see an appropriate message in the subject$/) do
  current_email.should have_subject("Booking Confirmation - Stamford Squash Club")
end

Then(/^I should see the date, time and court number for the booking in the email body$/) do
  current_email.default_part_body.to_s.should include(current_booking.time_and_place)
end

Then(/^my opponent should receive an email$/) do
  unread_emails_for(opponent.email).size.should == 1
end

Then(/^there should be a link to edit the booking in the email body$/) do
  current_email.default_part_body.to_s.should have_link("Edit booking")
end

Then(/^an email should be sent to me$/) do
  unread_emails_for(current_user.email).size.should == 1
end