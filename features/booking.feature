Feature: Registered users should be able to book a court
  In order to ensure the integrity of the booking system
  An authenticated user
  Should be able to book an available court with valid constraints
  
  Background:
    Given there are 4 courts
    Given a standard user exists with id: 999 and username: "joebloggs" and password: "password"
    And the courts are available from "06:20" to "22:00" with a 40 minute time slot
    And the courts can be booked up to 3 weeks in advance
    And the peak hours are "17:40" and "19:40"
    And no more than 3 courts can be booked during peak times
    And todays date and time is "01 September 2013 17:00"
  
  Scenario: Making a new booking
    Given I login as "joebloggs" with password "password"
    When I go to the new booking page
    Then I should see "joebloggs"
    And there should be a hidden field within booking called "user_id" with value "999"
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "03 September 2013 19:00"
    And I should not be able to select "joebloggs" from "booking_opponent_user_id"
    And I click the "Submit Booking" button
    Then I should see "Booking successfully created."
    
  Scenario: Making a new booking against an opponent
    Given I login as "joebloggs" with password "password"
    And a user exists with username: "Worthy opponent" and email: "worthyopponent@example.com"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "03 September 2013 19:00"
    And I select "Worthy opponent" from "Opponent"
    And I click the "Submit Booking" button
    Then I should see "Booking successfully created."
    
  Scenario: Making a new booking in the past
    Given I login as "joebloggs" with password "password"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "29 August 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "Booking date and time must be after 01 September 2013 17:00"
    
  Scenario: making a new booking too far into the future
    Given I login as "joebloggs" with password "password"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "23 September 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "Booking date and time must be before 22 September 2013 17:00"
    
  Scenario: making more than three bookings during peak periods
    Given I login as "joebloggs" with password "password"
    And there is a booking with user_id: 999 and court_number: 1 and booking_date_and_time: "02 September 2013 19:00"
    And there is a booking with user_id: 999 and court_number: 2 and booking_date_and_time: "03 September 2013 17:40"
    And there is a booking with user_id: 999 and court_number: 3 and booking_date_and_time: "04 September 2013 19:40"
    When I go to the new booking page
    And I fill in "Court Number" with "4"
    And I fill in "Date and Time" with "03 September 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "No more than 3 bookings are allowed during peak hours in the same week."
    
  Scenario: making a duplicate booking
    Given I login as "joebloggs" with password "password"
    And there is a booking with user_id: 999 and court_number: 1 and booking_date_and_time: "02 September 2013 19:00"
    When I go to the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "02 September 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "A booking already exists for 02 September 2013 19:00 on court 1"
    
  Scenario: deleting a booking for the current user
    Given I login as "joebloggs" with password "password"
    When I view the booking with user_id: 999 and court_number: 1 and booking_date_and_time: "02 September 2013 19:00"
    And I click the "Delete booking" link
    Then I should see "Booking successfully deleted"
    
  Scenario: viewing a booking for another user
    Given I login as "joebloggs" with password "password"
    When I view the booking with user_id: 111 and court_number: 1 and booking_date_and_time: "02 September 2013 19:00"
    Then I should not see "Delete booking"
    
  Scenario: deleting a booking after the start time
    Given I login as "joebloggs" with password "password"
    Then I view the booking with user_id: 999 and court_number: 1 and booking_date_and_time: "02 September 2013 19:00"
    And todays date and time is "02 September 2013 19:40"
    And I click the "Delete booking" link
    Then I should see "Unable to delete booking"
    
    
    
    
    
    
    
  
