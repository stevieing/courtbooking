@users @admin
Feature: manage users
  In order to maintain the system
  An admin user
  Should be able to manage the users
  
  Background:
    Given the courts are setup
    And I am signed in as an administrator
    
  Scenario: Manage members
    Given I go to the admin users page
    Then I should see a list of all of the current users
    
  Scenario: Edit an existing user successfully
    Given I go to the admin users page
    When I edit an existing user
    And I update the email address
    Then I should see a message with the text User successfully updated
    
  Scenario: Edit an existing user unsuccessfully
    Given I go to the admin users page
    When I edit an existing user
    And I update the email address with an invalid value
    Then I should see a message with the text error prohibited this record from being saved
    
  Scenario: Add a new user
    Given I go to the admin users page
    When I follow the link to add a new user
    And I fill in valid user details
    And I submit the user
    Then I should see a message with the text User successfully created
    
  Scenario Outline: Add a new user with blank fields
    Given I go to the admin users page
    When I follow the link to add a new user
    And I fill in valid user details
    But I leave the <field> blank
    And I submit the user
    Then I should see a message with the text <message>
    
    Examples:
      | field                   | message                                      |
      | Password confirmation   | Password confirmation doesn't match Password |
      | Password                | Password can't be blank                      |
      | Username                | Username can't be blank                      |
      | Email                   | Email can't be blank                         |
      
  Scenario: Delete an existing user
    Given I go to the admin users page
    When I follow the link to delete an existing user
    Then I should see a message with the text User successfully deleted

  @javascript @authorisation
  Scenario: Add a new user with permissions
    Given I go to the admin users page
    When I follow the link to add a new user
    And I fill in valid user details
    And I fill in email with an email address
    And I add some valid permissions
    And I submit the user
    Then I should see a message with the text User successfully created
    And the user should have some valid permissions

  @javascript @authorisation
  Scenario: Edit an existing user with permissions
    Given there is a user with standard permissions
    When I go to the admin users page
    And I edit the user
    And I remove a permission
    And I submit the user
    Then I should see a message with the text User successfully updated
    And 1 permission should have been deleted from the user
