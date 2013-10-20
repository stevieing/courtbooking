@email
Feature: email
  In order to ensure confirmation of booking changes
  A user who has created, modified or deleted a booking
  Should receive an email with the necessary information
  
  Background:
    Given todays date is "01 September 2013" and the time is "17:00"
    And the courts are setup
  
  Scenario: Create a new booking
    Given I am signed in as a member
    When I have successfully created a new booking
    Then I should receive an email
    And I open the email
    Then I should see an appropriate message in the subject
    And I should see the date, time and court number for the booking in the email body
    And there should be a link to edit the booking in the email body
  
  @opponent  
  Scenario: Create a new booking with an opponent
    Given I am signed in as a member
    When I have successfully created a new booking against an opponent
    Then I should receive an email
    And my opponent should receive an email
    
  Scenario: Updating an existing booking
    Given I am signed in as a member
    And I have created a booking
    When I go to the courts page
    And I follow a link to edit the booking
    And I submit the booking
    Then I should receive an email
    
  Scenario: Deleting an existing booking
    Given I am signed in as a member
    And I have created a booking
    When I go to the courts page
    And I follow a link to edit the booking
    And I delete the booking
    Then I should receive an email
  
  @user_no_mail
  Scenario: Create a new booking with email alerts turned off
    Given I am signed in as a member
    When I have successfully created a new booking
    Then I should receive no email
    
  @user_no_mail
  Scenario: Updating an existing booking with email alerts turned off
    Given I am signed in as a member
    And I have created a booking
    When I go to the courts page
    And I follow a link to edit the booking
    And I submit the booking
    Then I should receive no email
  
  @user_no_mail
  Scenario: Deleting an existing booking with email alerts turned off
    Given I am signed in as a member
    And I have created a booking
    When I go to the courts page
    And I follow a link to edit the booking
    And I delete the booking
    Then I should receive no email