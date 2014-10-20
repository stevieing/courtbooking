@managecourts @admin
Feature: manage courts
  In order to maintain the system
  An authorised user
  Should be able to manage the courts

  Background:
    Given the courts are setup
    And I am signed in as an administrator

  Scenario: Manage courts
    Given I go to the admin courts page
    Then I should see a list of all of the courts

  @newcourtnumber
  Scenario: Add a new court
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I submit the court
    Then I should see a message with the text Court successfully created

  Scenario: Add a new court with an invalid number
    Given I go to the admin courts page
    When I follow the link to add a new court
    But I fill in the Court number with an invalid value
    And I submit the court
    Then I should see a message with the text Number has already been taken

  @javascript @newcourtnumber
  Scenario: Add a new court with a valid opening time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add 1 valid opening time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have opening times

  @javascript
  Scenario: Add a new court with an invalid opening time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I add 1 invalid opening time
    And I submit the court
    Then I should see a message with the text Time To must be after Time From

  @javascript @newcourtnumber
  Scenario: Add a new court with multiple opening times
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add 2 valid opening times
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 2 opening times

  @javascript @newcourtnumber
  Scenario: Rmove a freshly added opening time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add 2 valid opening times
    And I remove the additional opening time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 1 opening time

  @javascript @newcourtnumber
  Scenario: Add a new court with a valid peak time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add 1 valid peak time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have peak times

  @javascript
  Scenario: Add a new court with an invalid peak time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I add 1 invalid peak time
    And I submit the court
    Then I should see a message with the text Time To must be after Time From

  @javascript @newcourtnumber
  Scenario: Add a new court with multiple peak times
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add 2 valid peak times
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 2 peak times

  @javascript @newcourtnumber
  Scenario: Remove a freshly added peak time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add 2 valid peak times
    And I remove the additional peak time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 1 peak time

  @javascript
  Scenario: Modify an existing courts opening times
    Given There is a court with a number of opening times
    When I go to the admin courts page
    And I edit an existing court
    And I remove an opening time
    And I submit the court
    Then I should see a message with the text Court successfully updated
    And 1 opening time should have been deleted from the court

  @javascript
  Scenario: Modify an existing courts peak times
    Given There is a court with a number of peak times
    When I go to the admin courts page
    And I edit an existing court
    And I remove a peak time
    And I submit the court
    Then I should see a message with the text Court successfully updated
    And 1 peak time should have been deleted from the court

  Scenario: Delete an existing court
    Given I go to the admin courts page
    And I delete an existing court
    Then I should see a message with the text Court successfully deleted
