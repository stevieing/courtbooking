@bookings @admin
Feature: Administrative users should be able to book a court
  In order to ensure the integrity of the booking system
  An authenticated user
  Should be able to book an available court with valid constraints
  
  Background:
    Given the courts are setup and the peak hours settings are in place
    And todays date is "01 September 2013" and the time is "17:00"
    And I am signed in as an administrator
  
  Scenario: Making a new booking
    Given I go to the new booking page
    Then I should see my username
    When I fill in valid booking details
    And I submit the booking
    Then I should see a message that the booking has been made
  
  @opponent
  Scenario: Making a new booking against an opponent
    Given I go to the new booking page
    When I fill in valid booking details
    And I select an opponent
    But I should not be able to select myself
    And I submit the booking
    Then I should see a message that the booking has been made
    
  Scenario: Making a new booking in the past
    Given I go to the new booking page
    When I fill in valid booking details
    But I try to book a date in the past
    And I submit the booking
    Then I should see a message telling me the booking must be in the future
    
  Scenario: making a new booking too far into the future
    When I go to the new booking page
    When I fill in valid booking details
    But I try to book a date too far into the future
    And I submit the booking
    Then I should see a message telling me the booking is too far into the future
   
  Scenario: making more than three bookings during peak periods
    Given I have already created the maximum number of bookings during peak hours
    When I go to the new booking page
    When I fill in the booking details
    But I try to book a date during peak hours
    And I submit the booking
    Then I should see a message telling me I cannot make another booking during peak hours
    
  Scenario: making a duplicate booking
    Given I have created a booking 
    When I go to the new booking page
    When I fill in the booking details
    But I use the details for a booking that has already been created
    And I submit the booking
    Then I should see a message telling me I cannot create a duplicate booking
    
  Scenario: deleting a booking for the current user
    Given I have created a booking
    When I view the booking I have created
    And I delete the booking
    Then I should see a message telling me the booking has been deleted
    
  Scenario: deleting a booking after the start time
    Given I have created a booking
    When I view the booking I have created
    But the booking is in the past
    And I delete the booking
    Then I should see a message telling me the booking cannot be deleted
  
  @opponent
  Scenario: editing an existing booking
    Given I have created a booking
    When I edit the booking I have created
    And I should see "Edit booking"
    And I should see my username
    And I select an opponent
    And I submit the booking
    Then I should see a message telling me the booking has been updated
  
  Scenario: editing playing at of existing booking
    Given I have created a booking
    When I edit the booking I have created
    But I change playing at
    And I submit the booking
    Then I should see a message telling me Playing at cannot be changed
    
  Scenario: editing court number of existing booking
    Given I have created a booking
    When I edit the booking I have created
    But I change the court number
    And I submit the booking
    Then I should see a message telling me Court number cannot be changed