Feature: Users cannot access certain areas of the system without logging in
  In order to protect the system from unauthorized access
  An anonymous user
  Should not have access to the system
  
  Background:
    Given the courts are setup
  
  Scenario: Sign-in successfully
    Given a user exists with username: "joebloggs" and password: "password"
    When I go to the sign_in page
    And I login as "joebloggs" with password "password"
    Then I should see a link to "SIGN OUT"
    And I should see "Signed in as: joebloggs"
    
  Scenario Outline: Sign-in unsuccessfully
    Given a user exists with username: "joebloggs" and password: "password"
    When I go to the sign_in page
    And I fill in "Username" with "<username>"
    And I fill in "Password" with "<password>"
    And I click the "sign in" button
    Then I should see "Incorrect username or password"
    And I should not see a link to "SIGN OUT"
    
    Examples:
      | username  | password    |
      |           |             |
      |joebloggs  |             |
      |           |password     |
      |bad user   |password     |
      |joebloggs  |bad password |
      
  Scenario: Visiting the sign_in page
    Given a guest user
    When I go to the sign_in page
    Then I should be on the sign_in page

  Scenario Outline: Redirecting to sign_in page
    Given a guest user
    When I go to the <path> page
    Then I should be redirected to the sign_in page
    
    Examples:
      | path      |
      | bookings  |
    
  Scenario: Sign-out successfully
    Given a user exists with username: "joebloggs" and password: "password"
    And I login as "joebloggs" with password "password"
    When I click the "SIGN OUT" link
    Then I should be redirected to the home page
    And I should see "Signed out successfully"
    And I should see a link to "SIGN IN"
    
  Scenario: Forgotten password
    Given PENDING
  
  Scenario: Change password
    Given PENDING
    
    
    