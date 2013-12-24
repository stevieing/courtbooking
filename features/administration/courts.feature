@managecourts @admin
Feature: manage courts
  In order to maintain the system
  An authorised user
  Should be able to manage the courts
  
  Background:
    Given the courts are setup
    And I am signed in as an administrator
    
  Scenario: Manage courts
    Given I go to the admin courts page
    Then I should see a list of all of the courts
    
  Scenario: Add a new court
    Given I go to the admin courts page
    When I follow the link to add a new court
    And the Court number field should be disabled
    And I submit the court
    Then I should see a message with the text Court successfully created