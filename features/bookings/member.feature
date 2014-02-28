@bookings
Feature: Members should be able to book a court
  In order to ensure the integrity of the booking system
  An authenticated user
  Should be able to book an available court with valid constraints
  
  Background:
    Given todays date is "01 September 2013" and the time is "17:00"
    And the courts are setup
    And I am signed in as a member
  
  @opponent  
  Scenario: viewing a booking for another user as a member
    Given a booking has been created by another user
    When I view the booking they have created
    Then I should not be able to delete the booking
    
  @opponent
  Scenario: editing an existing booking
    Given I have created a booking
    When I edit the booking I have created
    And I should see "Edit booking"
    And I should see my Full name
    And I select an opponent
    And I submit the booking
    Then I should see a message with the text Booking successfully updated
    
  @opponent
  Scenario: Not selecting myself as an opponent
    When I go to the courts page
    And I follow a link to create a new booking
    Then I should see valid booking details
    But I should not be able to select myself as an opponent
    
    
  Scenario: Making a new booking
    When I go to the courts page
    And I follow a link to create a new booking
    Then I should see valid booking details
    And I submit the booking
    Then I should see a message with the text Booking successfully created
  
  @opponent  
  Scenario: Making a new booking against an opponent
    When I go to the courts page
    And I follow a link to create a new booking
    Then I should see valid booking details
    And I select an opponent
    And I submit the booking
    Then I should see a message with the text Booking successfully created

  Scenario: Deleting a booking
    Given I have created a booking
    When I go to the courts page
    And I follow a link to edit the booking
    And I delete the booking
    Then I should see a message with the text Booking successfully deleted
    
  Scenario: Viewing my bookings
    Given I have created a number of bookings in the future
    When I go to the bookings page
    Then I should see a list of the bookings I have created
    And I should be able to edit each booking
    And I should be able to delete each booking
    
  Scenario: Viewing a booking in the past
    Given I have created a booking
    But the booking is in the past
    When I go to the bookings page
    Then I should see my booking
    But I should not be able to edit the booking
    And I should not be able to delete the booking
    
  Scenario: Returning to the booking page after editing a booking
    Given I have created a booking
    When I go to the bookings page
    And I follow the link to edit the booking
    And I submit the booking
    Then I should be redirected to the bookings page
  
  Scenario: Returning to the booking page after deleting a booking
     Given I have created a booking
     When I go to the bookings page
     And I follow the link to delete the booking
     Then I should be redirected to the bookings page
  
  @opponent, @other_member  
  Scenario: Viewing bookings for another user
    Given I have created a booking
    And another user has also created a booking
    When I go to the bookings page
    Then I should see a list of the bookings I have created
    But I should not see a list of the bookings they have created