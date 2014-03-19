@settings @admin
Feature: manage settings
  In order to maintain the system
  An admin user
  Should be able to manage the settings

  Background:
    Given the courts are setup
    And I am signed in as an administrator

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