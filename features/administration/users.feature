@users @admin
Feature: manage users
  In order to maintain the system
  An admin user
  Should be able to manage the users
  
  Background:
    Given the courts are setup
    And I am signed in as an administrator
    
  Scenario: Manage users
    Given I go to the admin users page
    Then I should see a list of all of the current users
    