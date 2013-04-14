Feature: Users cannot access the system without logging in
  In order to protect the system from unauthorized access
  An anonymous user
  Should not have access to the system
  
  Scenario: Sign-in successfully
    Given a user exists with username: 'joebloggs'
    When I go to the sign_in page
    And I login with the correct credentials
    Then I should see a link to "Sign out"
    And I should see "Signed in as: joebloggs"
    
  Scenario Outline: Sign-in unsuccessfully
    Given a user exists with username: 'joebloggs'
    When I go to the sign_in page
    And I fill in "Username" with "<username>"
    And I fill in "Password" with "<password>"
    And I click the "sign in" button
    Then I should see "Incorrect username or password"
    And I should not see a link to "Sign out"
    
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
      | home      |
      | courts    |
      | bookings  |
    
  Scenario: Sign-out successfully
    Given I am logged in
    When I click the "Sign out" link
    Then I should be redirected to the sign_in page
    And I should see "Signed out successfully"
    
  Scenario: Forgotten password
    Given PENDING
  
  Scenario: Change password
    Given PENDING
    
    
    