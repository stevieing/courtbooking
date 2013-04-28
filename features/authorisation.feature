@authorisation
Feature: Users can only access permitted areas
  In order to ensure that Users only access the correct areas
  An authenticated User
  Should have access to areas for which they have permissions
  
  Background:
    Given there are 4 courts
    And the courts are available from "06:40" to "22:00" with a 40 minute time slot
    And the courts can be booked up to 3 weeks in advance
    And todays date is "01 September 2013"
  
  Scenario Outline: Visiting pages as a defined User type
    Given I am logged in as a <user_type> User
    When I go to the <page> page
    Then I should see "<response>"
    
    Examples:
      | user_type   | page        | response        |
      | standard    | admin       | Not authorised  |
      | standard    | courts      | 01 Sep 2013     |
      | standard    | bookings    | Bookings        |
      | admin       | admin       | Admin           |

  Scenario: Visiting the home page as a standard User
    Given I am logged in as a standard User
    When I go to the home page
    Then I should see a link to "BOOKINGS"
    And I should see a link to "COURTS"
    And I should not see a link to "ADMIN"
    
  Scenario: Visiting the home page as an admin User
    Given I am logged in as an admin User
    When I go to the home page
    Then I should see a link to "BOOKINGS"
    And I should see a link to "COURTS"
    And I should see a link to "ADMIN"