@courts
Feature: Users should be able to browse the status of courts
  In order to book courts
  Any user
  Should be able to browse the courts and view bookings

  # The date and time must be set up before the courts.
  Background:
    Given todays date is "01 September 2013" and the time is "17:00"
    And the courts are setup

  Scenario: Browsing the courts for a time slot 5 days from today
    When I go to the courts page
    And I view the courts for 5 days from today
    Then I should be redirected to the courts page for that day
    And I should see the correct date

  Scenario: Bookings in the past
    Given I am signed in
    When there are two bookings one after the other for tomorrow
    And it is tomorrow after the first booking has started
    And I go to the courts page
    Then I should not be able to edit the first booking
    But I should be able to edit the second booking

  Scenario: All the courts are closed
    Given All of the courts are closed for a fixed period
    When I go to the courts page
    And I should see a message telling me when and why the courts are closed

  Scenario: All the courts are closed for several days
    Given All of the courts are closed for a fixed period for 5 days
    When I go to the courts page
    And I should see a message telling me when and why the courts are closed
