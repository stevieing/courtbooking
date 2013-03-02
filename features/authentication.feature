Feature: Authentication
  In order to use the court booking system
  As a registered user
  I want to to be able to login and logout
  
  Scenario: Login successfully
    Given a user exists with username: joebloggs
    When I go to the login page
    And I login with the correct credentials
    Then I should see "Signed in Successfully"