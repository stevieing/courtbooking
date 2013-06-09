@bookings
Feature: Members should be able to book a court
  In order to ensure the integrity of the booking system
  An authenticated user
  Should be able to book an available court with valid constraints
  
  Background:
    Given todays date is "01 September 2013" and the time is "17:00"
    And the courts are setup and the peak hours settings are in place
    And I am signed in as a member
  
  @opponent  
  Scenario: viewing a booking for another user as a member
    Given a booking has been created by another user
    When I view the booking they have created
    Then I should not be able to delete the booking