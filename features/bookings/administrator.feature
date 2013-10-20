@bookings @admin
Feature: Administrative users should be able to book a court
  In order to ensure the integrity of the booking system
  An authenticated user
  Should be able to book an available court with valid constraints
  
  Background:
    Given todays date is "01 September 2013" and the time is "17:00"
    And the courts are setup
    And I am signed in as an administrator
  
  @opponent
  Scenario: editing an existing booking
    Given I have created a booking
    When I edit the booking I have created
    And I should see "Edit booking"
    And I should see my username
    And I select an opponent
    And I submit the booking
    Then I should see a message with the text Booking successfully updated
    
  Scenario: Deleting a booking for another user
    Given a booking has been created by another user
    When I edit the booking they have created
    And I delete the booking
    Then I should see a message with the text Booking successfully deleted
    
  @opponent, @other_member  
  Scenario: Viewing bookings for another user
    Given there are a number of valid bookings for myself and another member for the next day
    When I go to the bookings page
    Then I should see a list of the bookings I have created
    And I should see a list of the bookings they have created
