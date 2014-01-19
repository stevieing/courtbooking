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
  
  @newcourtnumber  
  Scenario: Add a new court with a valid opening time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add a valid opening time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have opening times
    
  Scenario: Add a new court with an invalid opening time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I add a valid opening time
    But I fill in time from with an invalid value for the opening time
    And I submit the court
    Then I should see a message with the text Time from should be in format hh:mm
  
  @javascript @newcourtnumber  
  Scenario: Add a new court with multiple opening times
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add a valid opening time
    And I add an additional opening time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 2 opening times

  @javascript @newcourtnumber
  Scenario: Rmove a freshly added opening time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add a valid opening time
    And I add an additional opening time
    And I remove the additional opening time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 1 opening time

  @newcourtnumber  
  Scenario: Add a new court with a valid peak time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add a valid peak time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have peak times
    
  Scenario: Add a new court with an invalid peak time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I add a valid peak time
    But I fill in time from with an invalid value for the peak time
    And I submit the court
    Then I should see a message with the text Time from should be in format hh:mm

  @javascript @newcourtnumber  
  Scenario: Add a new court with multiple peak times
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add a valid peak time
    And I add an additional peak time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 2 peak times

  @javascript @newcourtnumber
  Scenario: Rmove a freshly added peak time
    Given I go to the admin courts page
    When I follow the link to add a new court
    And I fill in the Court number with a valid value
    And I add a valid peak time
    And I add an additional peak time
    And I remove the additional peak time
    And I submit the court
    Then I should see a message with the text Court successfully created
    And the court should have 1 peak time