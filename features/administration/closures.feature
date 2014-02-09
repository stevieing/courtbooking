@closures @admin
Feature: manage closures
  In order to make sure courts can be closed for maintenance and other standard reasons
  An admin user
  Should be able to manage court closures

  Background:
    Given the courts are setup
    And I am signed in as an administrator

  Scenario: Add a closure
  	Given I go to the admin closures page
  	When I follow the link to add a new closure
    When I fill in valid closure details
    And I add a list of courts to be closed
    And I submit the closure
    Then I should see a message with the text Closure successfully created

  Scenario: Add a closure without specifying a court
    Given I go to the admin closures page
    When I follow the link to add a new closure
    And I fill in valid closure details
    And I submit the closure
    Then I should see a message with the text Courts can't be blank

  Scenario: Edit an existing closure
    Given I have created a court closure
    When I go to the admin closures page
    And I edit the closure I have created
    And I remove a court
    And I submit the closure
    Then I should see a message with the text Closure successfully updated
    And the closure should have 1 less court

  Scenario: Edit an existing closure unsuccessfully
    Given I have created a court closure
    When I go to the admin closures page
    And I edit the closure I have created
    And I remove all of the courts
    And I submit the closure
    Then I should see a message with the text Courts can't be blank

  Scenario: Delete an existing closure
    Given I have created a court closure
    When I go to the admin closures page
    And I delete the closure I have created
    Then I should see a message with the text Closure successfully deleted
