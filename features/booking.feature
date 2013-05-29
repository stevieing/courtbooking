Feature: Registered users should be able to book a court
  In order to ensure the integrity of the booking system
  An authenticated user
  Should be able to book an available court with valid constraints
  
  Background:
    Given there are 4 courts
    Given an admin user exists with id: 999 and username: "joebloggs" and password: "password"
    And the courts are available from "06:20" to "22:00" with a 40 minute time slot
    And the courts can be booked up to 3 weeks in advance
    And the peak hours are "17:40" and "19:40"
    And no more than 3 courts can be booked during peak times
    And todays date and time is "01 September 2013 17:00"
  
  Scenario: Making a new booking
    Given I login as "joebloggs" with password "password"
    When I go to the new booking page
    Then I should see "joebloggs"
    And I fill in "Court Number" with "1"
    And I fill in "Playing at" with "03 September 2013 19:00"
    And I should not be able to select "joebloggs" from "booking_opponent_user_id"
    And I click the "Submit Booking" button
    Then I should see "Booking successfully created."
    
  Scenario: Making a new booking against an opponent
    Given I login as "joebloggs" with password "password"
    And a user exists with username: "Worthy opponent" and email: "worthyopponent@example.com"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Playing at" with "03 September 2013 19:00"
    And I select "Worthy opponent" from "Opponent"
    And I click the "Submit Booking" button
    Then I should see "Booking successfully created."
    
  Scenario: Making a new booking in the past
    Given I login as "joebloggs" with password "password"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Playing at" with "29 August 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "Playing at must be after 01 September 2013 17:00"
    
  Scenario: making a new booking too far into the future
    Given I login as "joebloggs" with password "password"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Playing at" with "23 September 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "Playing at must be before 22 September 2013 17:00"
    
  Scenario: making more than three bookings during peak periods
    Given I login as "joebloggs" with password "password"
    And there is a booking with user_id: 999 and court_number: 1 and playing_at: "02 September 2013 19:00"
    And there is a booking with user_id: 999 and court_number: 2 and playing_at: "03 September 2013 17:40"
    And there is a booking with user_id: 999 and court_number: 3 and playing_at: "04 September 2013 19:40"
    When I go to the new booking page
    And I fill in "Court Number" with "4"
    And I fill in "Playing at" with "03 September 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "No more than 3 bookings are allowed during peak hours in the same week."
    
  Scenario: making a duplicate booking
    Given I login as "joebloggs" with password "password"
    And there is a booking with user_id: 999 and court_number: 1 and playing_at: "02 September 2013 19:00"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Playing at" with "02 September 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "A booking already exists for 02 September 2013 19:00 on court 1"
    
  Scenario: deleting a booking for the current user
    Given I login as "joebloggs" with password "password"
    When I view the booking with user_id: 999 and court_number: 1 and playing_at: "02 September 2013 19:00"
    And I click the "Delete booking" link
    Then I should see "Booking successfully deleted"
    
  Scenario: viewing a booking for another user as a standard user
    Given a standard user exists with id: 222 and username: "standard user" and password: "password" and email: "standarduser@example.com"
    When I login as "standard user" with password "password"
    When I view the booking with user_id: 111 and court_number: 1 and playing_at: "02 September 2013 19:00"
    Then I should not see "Delete booking"
    
  Scenario: deleting a booking after the start time
    Given I login as "joebloggs" with password "password"
    When I view the booking with user_id: 999 and court_number: 1 and playing_at: "02 September 2013 19:00"
    And todays date and time is "02 September 2013 19:40"
    And I click the "Delete booking" link
    Then I should see "Unable to delete booking"
    
  Scenario: editing an existing booking
    Given a standard user exists with id: 111 and username: "worthy opponent" and email: "worthyopponent@example.com"
    And a standard user exists with id: 222 and username: "Nicol David" and email: "nicoldavid@example.com"
    When I login as "joebloggs" with password "password"
    And I edit the booking with user_id: 999 and opponent_user_id: 111 and court_number: 1 and playing_at: "02 September 2013 19:00"
    Then I should see "Edit booking"
    And I should see "joebloggs"
    And I should see value "02 September 2013 19:00" in "Playing at"
    And I should see "worthy opponent"
    And I select "Nicol David" from "Opponent"
    When I click the "Submit Booking" button
    Then I should see "Booking successfully updated"
  
  Scenario: editing playing at of existing booking
    Given I login as "joebloggs" with password "password"
    When I edit the booking with user_id: 999 and court_number: 1 and playing_at: "02 September 2013 19:00"
    And I fill in "Playing at" with "03 September 2013 19:00"
    When I click the "Submit Booking" button
    Then I should see "Playing at cannot be changed"
    
  Scenario: editing court number of existing booking
    Given I login as "joebloggs" with password "password"
    When I edit the booking with user_id: 999 and court_number: 1 and playing_at: "02 September 2013 19:00"
    And I fill in "Court Number" with "2"
    When I click the "Submit Booking" button
    Then I should see "Court number cannot be changed"
    
    
    
    
    
    
    
    
    
  
