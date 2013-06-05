@registration
Feature: Registration
  As an unregistered user
  I should not be able to register
  
  Scenario: Try and register via sign in page
    Given I am an unregistered user
    When I go to the sign in page
    Then I should not be able to sign up