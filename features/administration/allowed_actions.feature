@allowedactions @admin
Feature: Allowed actions
  In order to maintain access to areas for other members
  An admin user
  Should be able to manage allowed actions

  Background:
    Given the courts are setup
    And I am signed in as an administrator

  Scenario: Manage allowed actions
    Given I go to the admin allowed_actions page
    Then I should see a list of all of the allowed actions

  Scenario: Add a new allowed action sucessfully
    Given I go to the admin allowed_actions page
    When I follow the link to add a new allowed action
    And I fill in valid allowed action details
    And I submit the allowed action
    Then I should see a message with the text Allowed action successfully created

  Scenario: Add a new allowed action unsucessfully
    Given I go to the admin allowed_actions page
    When I follow the link to add a new allowed action
    And I fill in valid allowed action details
    But I leave the Name blank
    And I submit the allowed action
    Then I should see a message with the text error prohibited this record from being saved

  Scenario: Edit an allowed action
    Given I have created an allowed action
    When I go to the admin allowed_actions page
    And I edit the allowed action I have created
    And I modify the name
    And I submit the allowed action
    Then I should see a message with the text Allowed action successfully updated

  Scenario: Delete an allowed action
    Given I have created an allowed action
    When I go to the admin allowed_actions page
    And I delete the allowed action I have created
    Then I should see a message with the text Allowed action successfully deleted