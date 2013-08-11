@administration @admin
Feature: administration
  In order to maintain the system
  An admin user
  Should be able to perform certain administrative tasks
  
  Background:
    Given the courts are setup
    And I am signed in as an administrator
    
  Scenario Outline: navigate to each administrative page
    Given I go to the admin page
    When I click on the "<heading>" link
    Then I should see "<heading>"
    
    Examples:
      | heading          |
      | Manage Settings  |
      | Manage Users     |
      
  Scenario: Manage settings
    Given I go to the admin settings page
    Then I should see a field for each setting
    
  Scenario: Update a setting successfully
    Given I go to the admin settings page
    When I update one of the settings
    Then I should see a message that the setting has been updated
    
  Scenario: Update a setting unsuccessfully
    Given I go to the admin settings page
    When I update one of the settings with an invalid value
    Then I should see a message that the setting has not been updated
    
    