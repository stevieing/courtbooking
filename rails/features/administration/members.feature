@members @admin
Feature: manage members
  In order to maintain the system
  An admin user
  Should be able to manage the members

  Background:
    Given the courts are setup
    And I am signed in as an administrator

  Scenario: Manage members
    Given I go to the admin members page
    Then I should see a list of all of the current members

  Scenario: Edit an existing member successfully
    Given I go to the admin members page
    When I edit an existing member
    And I update the email address
    And I submit the member
    Then I should see a message with the text Member successfully updated

  Scenario: Edit an existing member unsuccessfully
    Given I go to the admin members page
    When I edit an existing member
    And I update the email address with an invalid value
    And I submit the member
    Then I should see a message with the text error prohibited this record from being saved

  Scenario: Add a new member
    Given I go to the admin members page
    When I follow the link to add a new member
    And I fill in valid member details
    And I submit the member
    Then I should see a message with the text Member successfully created

  Scenario Outline: Add a new member with blank fields
    Given I go to the admin members page
    When I follow the link to add a new member
    And I fill in valid member details
    But I leave the <field> blank
    And I submit the member
    Then I should see a message with the text <message>

    Examples:
      | field                   | message                                      |
      | Password confirmation   | Password confirmation doesn't match Password |
      | Password                | Password can't be blank                      |
      | Username                | Username can't be blank                      |
      | Email                   | Email can't be blank                         |

  Scenario: Delete an existing member
    Given I go to the admin members page
    When I follow the link to delete an existing member
    Then I should see a message with the text Member successfully deleted

  @authorisation
  Scenario: Add a new member with permissions
    Given I go to the admin members page
    When I follow the link to add a new member
    And I fill in valid member details
    And I fill in email with an email address
    And I add some valid permissions
    And I submit the member
    Then I should see a message with the text Member successfully created
    And the member should have some valid permissions

  @authorisation
  Scenario: Edit an existing member with permissions
    Given there is a member with standard permissions
    When I go to the admin members page
    And I edit the member
    And I remove a permission
    And I submit the member
    Then I should see a message with the text Member successfully updated
    And 1 permission should have been deleted from the member
