@autocomplete
Feature: Members should be able to select an opponent when they make a booking
  In order to make it easy to select an opponent
  A member
  Should be able to type in the first few characters of a name

  Background:
    Given the courts are setup
    And I am signed in as a member

  @javascript
  Scenario: Successfully select an opponent
    Given the following list of members exist:
      | Mark Francis    |
      | Marcus Smith    |
      | Mary Berry      |
      | Marianne Douche |
    When I go to the courts page
    And I follow a link to create a new booking
    And I fill in "Opponent" with "Mar"
    And I wait for 2 seconds
    Then I should see the following autocomplete options:
      | Mark Francis    |
      | Marcus Smith    |
      | Mary Berry      |
      | Marianne Douche |
    And I follow "Mark Francis"
    Then the field "Opponent" should have the value "Mark Francis"

  # TODO: there is a potential failure if the tests are run late at night (hmm!).
  # Due to the fact that Cucumber will be mothballed once Ember is introduced
  # as the front end no point in finding a permanent fix.
  @javascript
  Scenario: Add a dodgy opponent name
    When I go to the courts page
    And I follow a link to create a new booking
    Then I should see valid booking details
    And I fill in "Opponent" with some gobbledyegook
    And I submit the booking
    Then I should see a message with the text Booking successfully created