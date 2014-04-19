@records_helpers @users @admin
Feature: manage users
  In order to increase flexibility
  Any feature
  Should have access to some Ruby magic to check for lists of records

  Background:
    Given the courts are setup
    And I am signed in as an administrator

  Scenario: Ensure the RecordsHelper page_contains_all_xxx? method works
    Given I go to the admin members page
    When I use the RecordsHelper module
    Then I should be able to check for a list of all the current members
