@authentication
Feature: authentication
  In order to protect the system from unauthorised access
  An anonymous user
  Should not have access to restricted areas of the system

  Background:
    Given the courts are setup

  Scenario: sign in successfully
    Given I sign in with the correct credentials
    Then I should be able to sign out
    And I should see my Full name

  Scenario Outline: sign in unsuccessfully
    Given a user exists with username: "joebloggs", password: "password"
    When I go to the sign in page
    And I fill in "Username" with "<username>"
    And I fill in "Password" with "<password>"
    And I press the sign in button
    Then I should see an error message explaining that my username or password are wrong
    And I should not be able to sign out

    Examples:
      | username  | password    |
      |           |             |
      |joebloggs  |             |
      |           |password     |
      |bad user   |password     |
      |joebloggs  |bad password |

  Scenario: Visiting the sign in page
    Given I am not signed in
    When I go to the sign in page
    Then I should be on the sign in page

  Scenario Outline: Redirecting to sign in page
    Given I am not signed in
    When I go to the <path> page
    Then I should be redirected to the sign in page

    Examples:
      | path      |
      | bookings  |

  Scenario: Sign out successfully
    Given I am signed in
    When I sign out
    Then I should be redirected to the home page
    And I should see a signed out message
    And I should be able to sign in

  Scenario: Forgotten password
    Given I go to the sign in page
    When I click on the "Forgotten your password?" link
    And I complete the email address
    And I press the Send me reset password instructions button
    Then I should receive an email

  Scenario: Change password
    Given PENDING


