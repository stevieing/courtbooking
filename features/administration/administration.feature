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
      | Manage Courts    |
      | Manage Events    |
      | Send Emails      |
      | Run Reports      |

  Scenario: navigate to the closures page
    Given I go to the admin courts page
    When I click on the "Closures" link
    Then I should see "Court Closures"
