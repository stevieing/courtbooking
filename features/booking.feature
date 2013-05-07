Feature: Registered users should be able to book a court
  In order to ensure the integrity of the booking system
  An authenticated user
  Should be able to book an available court with valid constraints
  
  Background:
    Given there are 4 courts
    Given a standard user exists with id: 999 and username: "joebloggs" and password: "password"
    And the courts are available from "06:40" to "22:00" with a 40 minute time slot
    And the courts can be booked up to 3 weeks in advance
    And todays date and time is "01 September 2013 17:00"
  
  Scenario: Making a new booking
    Given I login as "joebloggs" with password "password"
    When I go the new booking page
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
    When I go the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "03 September 2013 19:00"
    And I select "Worthy opponent" from "Opponent"
    And I click the "Submit Booking" button
    Then I should see "Booking successfully created."
    
  Scenario: Making a new booking in the past
    Given I login as "joebloggs" with password "password"
    When I go the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "29 August 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "Booking must be in the future"
    
  Scenario: making a new booking too far into the future
    Given I login as "joebloggs" with password "password"
    When I go the new booking page
    And I fill in "Court Number" with "1"
    And I fill in "Date and Time" with "23 September 2013 19:00"
    And I click the "Submit Booking" button
    Then I should see "Booking is too far into the future"
