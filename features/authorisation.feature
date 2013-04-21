@authorisation
Feature: Users can only access permitted areas
  In order to ensure that Users only access the correct areas
  An authenticated User
  Should have access to areas for which they have permissions
  
  @create_court_variables
  Scenario Outline: Visiting pages as a defined User type
    Given I am logged in as a <user_type> User
    When I go to the <page> page
    Then I should see "<response>"
    
    Examples:
      | user_type   | page        | response        |
      | standard    | admin       | Not authorised  |
      | standard    | courts      | Courts          |
      | standard    | bookings    | Bookings        |
      | admin       | admin       | Admin           |
    
  Scenario: Visiting the home page as a standard User
    Given I am logged in as a standard User
    When I go to the home page
    Then I should see a link to "bookings"
    And I should not see a link to "admin"
    
  Scenario: Visiting the home page as an admin User
    Given I am logged in as an admin User
    When I go to the home page
    Then I should see a link to "bookings"
    And I should see a link to "admin"