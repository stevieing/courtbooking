Feature: Registration
  As an unregistered user
  I should not be able to register
  
  Scenario: Try and register via sign_in page
    Given I am an unregistered user
    When I go to the sign_in page
    Then I should not see a link to "Sign up"