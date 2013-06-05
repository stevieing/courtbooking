@authorisation
Feature: Users can only access permitted areas
  In order to ensure that users only access the correct areas
  An authenticated user
  Should only have access to areas for which they have permissions
  
  Background:
    Given the courts are setup
  
  Scenario Outline: Visiting admin pages as a member
    Given I am signed in as a member
    When I go to the admin page
    Then I should see "Not authorised"

  Scenario: Visiting the home page as a member
    Given I am signed in as a member
    When I go to the home page
    Then I should see a link to "BOOKINGS"
    And I should see a link to "COURTS"
    And I should not see a link to "ADMIN"
  
  @admin
  Scenario: Visiting the home page as an administrator
    Given I am signed in as an administrator
    When I go to the home page
    Then I should see a link to "ADMIN"