@user
Feature: user
  In order not to bother administrators
  Any member
  Should be able to modify their details

  Background:
    Given the courts are setup
    And I am signed in as a member

  Scenario: Modify my details successfully
    Given I go to the courts page
    When I follow the link to my details
    And I update the email address
    And I submit the user
    Then I should see a message with the text User successfully updated

  Scenario: Modify my details unsuccessfully
    Given I go to the courts page
    When I follow the link to my details
    And I update the email address with an invalid value
    And I submit the user
    Then I should see a message with the text error prohibited this record from being saved
