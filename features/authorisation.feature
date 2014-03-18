@authorisation
Feature: Users can only access permitted areas
  In order to ensure that users only access the correct areas
  An authenticated user
  Should only have access to areas for which they have permissions

  Background:
    Given todays date is "01 September 2013" and the time is "17:00"
    And the courts are setup

  Scenario: Visiting admin pages as a member
    Given I am signed in as a member
    When I go to the admin page
    Then I should not be authorised

  Scenario: Visiting the home page as a member
    Given I am signed in as a member
    When I go to the home page
    Then I should see a link to "BOOKINGS"
    And I should see a link to "COURTS"
    And I should see a link to "MY DETAILS"
    But I should not see a link to "ADMIN"

  Scenario: Visiting the home page as a guest
    Given I am not signed in
    When I go to the home page
    Then I should see a link to "SIGN IN"
    And I should see a link to "COURTS"
    But I should not see a link to "BOOKNGS"
    And I should not see a link to "ADMIN"

  @admin
  Scenario: Visiting the home page as an administrator
    Given I am signed in as an administrator
    When I go to the home page
    Then I should see a link to "ADMIN"

  @member
  Scenario: Creating a booking without permissions
    Given I am signed in as a member
    When I go to the courts page
    And I follow a link to create a new booking
    Then I should not be authorised

  @member
  Scenario: Editing a booking without permissions
    Given I am signed in as a member
    And I have permission to Create a new booking
    And I have created a booking
    When I edit the booking I have created
    Then I should not be authorised

  @member
  Scenario: Deleting a booking without permissions
    Given I am signed in as a member
    And I have permission to Create a new booking
    And I have created a booking
    And I have permission to Edit a booking
    When I edit the booking I have created
    Then I should not be able to delete the booking

  @member @adminpermissions
  Scenario Outline: navigate to each administrative page
    Given I am signed in as a member
    When I go to the admin page
    And I click on the "<heading>" link
    Then I should see "<heading>"

    Examples:
      | heading          |
      | Manage Settings  |
      | Manage Users     |
      | Manage Courts    |
      | Manage Events    |
