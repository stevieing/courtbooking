@events @admin
Feature: manage events
  In order to add league matches, coaching and competitions
  An admin user
  Should be able to manage events

  Background:
    Given the courts are setup
    And I am signed in as an administrator

  Scenario: Add an event
  	Given I go to the admin events page
  	When I follow the link to add a new event
    When I fill in valid event details
    And I add a list of courts for the event
    And I submit the event
    Then I should see a message with the text Event successfully created

  Scenario: Add an event without specifying a court
    Given I go to the admin events page
    When I follow the link to add a new event
    And I fill in valid event details
    And I submit the event
    Then I should see a message with the text Courts can't be blank

  Scenario: Edit an existing event
    Given I have created a court event
    When I go to the admin events page
    And I edit the event I have created
    And I remove a court
    And I submit the event
    Then I should see a message with the text Event successfully updated
    And the event should have 1 less court

  Scenario: Edit an existing event unsuccessfully
    Given I have created a court event
    When I go to the admin events page
    And I edit the event I have created
    And I remove all of the courts
    And I submit the event
    Then I should see a message with the text Courts can't be blank

  Scenario: Delete an existing event
    Given I have created a court event
    When I go to the admin events page
    And I delete the event I have created
    Then I should see a message with the text Event successfully deleted

  Scenario: Add an event with an overlapping booking
    Given I go to the admin events page
    When I follow the link to add a new event
    And I fill in valid event details
    And I add a list of courts to be closed
    But there is an overlapping booking
    And I check allow removal of of overlapping bookings/closures/event
    And I submit the event
    Then I should see a message with the text Event successfully created

  Scenario: Add an event with an overlapping booking unsuccessfully
    Given I go to the admin events page
    When I follow the link to add a new event
    And I fill in valid event details
    And I add a list of courts to be closed
    But there is an overlapping booking
    And I submit the event
    Then I should see a message with the text error prohibited this record from being saved
