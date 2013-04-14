Feature: Users should be able to browse the status of courts
  In order to book courts
  A registered user
  Should be able to browse the current status of each court
  
  Background:
    Given I am logged in
  
  Scenario: Browsing the courts for today
    Given there are 4 courts
    When I go to the courts page
    Then I should see a column for each court
    
  Scenario: Browsing the courts for a time slot
    Given the courts are available from "06:40" to "22:00" with a 40 minute time slot
    When I go to the courts page
    Then I should see a row for each time slot
    And I should see a time slot for each court